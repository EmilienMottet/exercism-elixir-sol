defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(markdown_file) do
    markdown_file
    |> lines
    |> Enum.map_join(&process_line/1)
    |> parse_tags
    |> wrap_ul
  end

  defp lines(raw_file) do
    String.split(raw_file, "\n")
  end

  defp count_header("#" <> line, acc) do
    count_header(line, acc + 1)
  end

  defp count_header(_line, acc) do
    acc
  end

  defp process_line("#" <> line) do
    size = count_header(line, 1)
    txt = String.slice(line, size..-1)
    generate_header(size, txt)
  end

  defp process_line("* " <> line) do
    generate_li(line)
  end

  defp process_line(line) do
    generate_p(line)
  end

  defp generate_header(size, text) do
    "<h#{size}>#{text}</h#{size}>"
  end

  defp generate_li(text) do
    "<li>#{text}</li>"
  end

  defp generate_p(text) do
    "<p>#{text}</p>"
  end

  defp parse_tags(txt) do
    txt
    |> String.replace(~r/__([^_]+)__/, "<strong>\\1</strong>")
    |> String.replace(~r/_([^_]+)_/, "<em>\\1</em>")
  end

  defp wrap_ul(text) do
    String.replace_suffix(
      String.replace(text, "<li>", "<ul>" <> "<li>", global: false),
      "</li>",
      "</li>" <> "</ul>"
    )
  end
end

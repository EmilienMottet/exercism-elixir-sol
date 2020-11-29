defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(?A) do
    "A\n"
  end

  def build_shape(char) do
    width = (char - ?A) * 2 + 1
    first = gen_rows(char - 1, width)
    (first ++ row(char, width) ++ Enum.reverse(first)) |> String.Chars.to_string()
  end

  defp gen_rows(?A, width) do
    row(?A, width)
  end

  defp gen_rows(char, width) do
    gen_rows(char - 1, width) ++ row(char, width)
  end

  defp row(?A, width) do
    outer = outer(div(width, 2))
    [outer ++ [?A] ++ outer ++ '\n']
  end

  defp row(char, width) do
    size = (char - 1 - ?A) * 2 + 1
    outer = outer(div(width - size - 2, 2))
    middle = space_out(char, size)
    [outer ++ middle ++ outer ++ '\n']
  end

  defp outer(size) do
    List.duplicate(?\s, size)
  end

  defp space_out(char, size) do
    [char | List.duplicate(?\s, size)] ++ [char]
  end
end

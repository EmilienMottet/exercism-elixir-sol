defmodule Grep do
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    files
    |> Enum.map(fn f ->
      f
      |> File.read!()
      |> String.split("\n")
      |> Stream.with_index(1)
      |> Stream.filter(fn {l, _i} ->
        c =
          cond do
            "-x" in flags and "-i" in flags ->
              l =~ ~r/^#{pattern}$/i

            "-x" in flags ->
              l == pattern

            "-i" in flags ->
              l =~ ~r/#{pattern}/i

            true ->
              String.contains?(l, pattern)
          end

        if "-v" in flags do
          not c and l |> String.trim() != ""
        else
          c
        end
      end)
      |> Enum.map(fn {l, i} -> %{line: l, index: i, print: l, file: f} end)
    end)
    |> List.flatten()
    |> custom_to_string(flags, files)
  end

  defp custom_to_string([], _flags, _files) do
    ""
  end

  defp custom_to_string(lines, ["-n" | flags], files) do
    custom_to_string(
      lines |> Enum.map(fn e -> %{e | print: "#{e.index}:#{e.line}"} end),
      flags,
      files
    )
  end

  defp custom_to_string(lines, flags, files) when length(files) > 1 do
    custom_to_string(
      lines |> Enum.map(fn e -> %{e | print: "#{e.file}:#{e.print}"} end),
      flags,
      nil
    )
  end

  defp custom_to_string(lines, ["-l" | flags], files) do
    custom_to_string(
      lines |> Stream.map(fn e -> %{e | print: e.file} end) |> Enum.uniq_by(fn e -> e.print end),
      flags,
      files
    )
  end

  defp custom_to_string(lines, [_t | flags], files) do
    custom_to_string(lines, flags, files)
  end

  defp custom_to_string(lines, [], _files) do
    res = lines |> Stream.map(fn e -> e.print end) |> Enum.join("\n")

    case res |> String.reverse() do
      "\n" <> _ -> res
      _ -> "#{res}\n"
    end
  end
end

defmodule OcrNumbers do
  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, charlist()}
  def convert(input) when rem(length(input), 4) != 0 do
    {:error, 'invalid line count'}
  end

  def convert(input) do
    cond do
      input |> Enum.any?(fn l -> Integer.mod(byte_size(l), 3) != 0 end) ->
        {:error, 'invalid column count'}

      true ->
        digit =
          input |> Enum.chunk_every(4) |> Enum.map(&identify_digits(&1, "")) |> Enum.join(",")

        {:ok, digit}
    end
  end

  defp identify_digits([" _ " <> t1, "|_|" <> t2, " _|" <> t3, "   " <> t4], acc) do
    identify_digits([t1, t2, t3, t4], acc <> "9")
  end

  defp identify_digits([" _ " <> t1, "|_|" <> t2, "|_|" <> t3, "   " <> t4], acc) do
    identify_digits([t1, t2, t3, t4], acc <> "8")
  end

  defp identify_digits([" _ " <> t1, "  |" <> t2, "  |" <> t3, "   " <> t4], acc) do
    identify_digits([t1, t2, t3, t4], acc <> "7")
  end

  defp identify_digits([" _ " <> t1, "|_ " <> t2, "|_|" <> t3, "   " <> t4], acc) do
    identify_digits([t1, t2, t3, t4], acc <> "6")
  end

  defp identify_digits([" _ " <> t1, "|_ " <> t2, " _|" <> t3, "   " <> t4], acc) do
    identify_digits([t1, t2, t3, t4], acc <> "5")
  end

  defp identify_digits(["   " <> t1, "|_|" <> t2, "  |" <> t3, "   " <> t4], acc) do
    identify_digits([t1, t2, t3, t4], acc <> "4")
  end

  defp identify_digits([" _ " <> t1, " _|" <> t2, " _|" <> t3, "   " <> t4], acc) do
    identify_digits([t1, t2, t3, t4], acc <> "3")
  end

  defp identify_digits([" _ " <> t1, " _|" <> t2, "|_ " <> t3, "   " <> t4], acc) do
    identify_digits([t1, t2, t3, t4], acc <> "2")
  end

  defp identify_digits(["   " <> t1, "  |" <> t2, "  |" <> t3, "   " <> t4], acc) do
    identify_digits([t1, t2, t3, t4], acc <> "1")
  end

  defp identify_digits([" _ " <> t1, "| |" <> t2, "|_|" <> t3, "   " <> t4], acc) do
    identify_digits([t1, t2, t3, t4], acc <> "0")
  end

  defp identify_digits(["", "", "", ""], acc) do
    acc
  end

  defp identify_digits(
         [
           <<_::binary-size(3)>> <> t1,
           <<_::binary-size(3)>> <> t2,
           <<_::binary-size(3)>> <> t3,
           <<_::binary-size(3)>> <> t4
         ],
         acc
       ) do
    identify_digits([t1, t2, t3, t4], acc <> "?")
  end
end

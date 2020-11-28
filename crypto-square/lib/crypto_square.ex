defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode("") do
    ""
  end

  def encode(str) do
    normalized = str |> String.replace([" ", ",", "!", ".", "'"], "") |> String.downcase()
    c = trunc(:math.ceil(:math.sqrt(byte_size(normalized))))
    chunked = normalized |> String.codepoints() |> Enum.chunk_every(c)
    transpose(chunked) |> Enum.join(" ")
  end

  defp transpose([[] | _]), do: []

  defp transpose(m) do
    [
      Enum.map(m, fn
        [] -> ""
        ar -> hd(ar)
      end)
      | transpose(
          Enum.map(m, fn
            [] -> []
            ar -> tl(ar)
          end)
        )
    ]
  end
end

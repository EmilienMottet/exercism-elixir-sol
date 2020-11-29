defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    cleantext = clean(plaintext)

    for c <- cleantext do
      permute(c)
    end
    |> add_space(0, [])
    |> to_string()
    |> String.reverse()
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher) do
    for c <- cipher |> to_charlist(), c != ?\s do
      permute(c)
    end
    |> to_string()
  end

  defp clean(text) do
    for c <- String.downcase(text) |> to_charlist,
        c in ?a..?z or c in ?0..?9 do
      c
    end
  end

  defp add_space([], _, acc) do
    acc
  end

  defp add_space([h | []], 4, acc) do
    add_space([], 0, [h | acc])
  end

  defp add_space([h | t], 4, acc) do
    add_space(t, 0, [' ', h | acc])
  end

  defp add_space([h | t], ct, acc) do
    add_space(t, ct + 1, [h | acc])
  end

  defp permute(c) when c in ?a..?z do
    ?z - (c - ?a)
  end

  defp permute(c) do
    c
  end
end

defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode("", _rails) do
    ""
  end

  def encode(str, 1) do
    str
  end

  def encode(str, rails) do
    str |> to_charlist() |> zigzag(rails) |> to_string()
  end

  defp zigzag(list, rails) do
    for i <- 1..rails, {x, ^i} <- zip_zigzag(list, rails) do
      x
    end
  end

  defp zip_zigzag(list, rails) do
    list
    |> Enum.zip(
      # zig
      1..(rails - 1)
      # zag
      |> Stream.concat(rails..2)
      # and repeat
      |> Stream.cycle()
    )
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, 1) do
    str
  end

  def decode(str, rails) do
    0..((str |> String.length()) - 1)
    |> zigzag(rails)
    |> Stream.with_index()
    |> Stream.map(fn {z_index, index} -> {z_index, str |> String.at(index)} end)
    |> Enum.sort_by(fn {z_index, _v} -> z_index end)
    |> Stream.map(fn {_z_index, v} -> v end)
    |> Enum.join()
  end
end

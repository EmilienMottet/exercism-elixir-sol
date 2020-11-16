defmodule Hexadecimal do
  @hex_map %{"a" => 10, "b" => 11, "c" => 12, "d" => 13, "e" => 14, "f" => 15}
           |> Map.merge(0..9 |> Map.new(fn x -> {Integer.to_string(x), x} end))

  @hex_key Map.keys(@hex_map)

  defp do_to_decimal([], {_i, acc}) do
    acc
  end

  defp do_to_decimal([h | t], {i, acc}) do
    p = :math.pow(16, i) |> round
    do_to_decimal(t, {i + 1, acc + h * p})
  end

  @doc """
    Accept a string representing a hexadecimal value and returns the
    corresponding decimal value.
    It returns the integer 0 if the hexadecimal is invalid.
    Otherwise returns an integer representing the decimal value.

    ## Examples

      iex> Hexadecimal.to_decimal("invalid")
      0

      iex> Hexadecimal.to_decimal("af")
      175

  """

  @spec to_decimal(binary) :: integer
  def to_decimal(hex) do
    arr = hex |> String.downcase() |> String.codepoints()

    if arr
       |> Enum.all?(fn
         x when x in @hex_key -> true
         _ -> false
       end) do
      reverse_arr = arr |> Stream.map(fn x -> @hex_map[x] end) |> Enum.reverse()
      do_to_decimal(reverse_arr, {0, 0})
    else
      0
    end
  end
end

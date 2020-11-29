defmodule AllYourBase do
  @doc """
  Given a number in base a, represented as a sequence of digits, converts it to base b,
  or returns nil if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: list
  def convert(_, base_a, base_b) when base_a <= 1 or base_b <= 1 do
    nil
  end

  def convert([], _base_a, _base_b) do
    nil
  end

  def convert(digits, base_a, base_b) do
    digits
    |> to_integer(base_a)
    |> to_array(base_b)
  end

  defp to_integer(digits, base) do
    digits =
      digits
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.map(fn
        {v, i} when v >= 0 and v < base -> int_pow(base, i) * v
        _ -> nil
      end)

    if digits |> Enum.member?(nil) do
      nil
    else
      digits |> Enum.sum()
    end
  end

  defp int_pow(x, n) do
    :math.pow(x, n) |> round
  end

  def to_array(nil, _base) do
    nil
  end

  def to_array(int, base) do
    to_array(int, base, [])
  end

  defp to_array(0, _base, []) do
    [0]
  end

  defp to_array(0, _base, arr) do
    arr
  end

  defp to_array(int, base, arr) do
    to_array(div(int, base), base, [rem(int, base) | arr])
  end
end

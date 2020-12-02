defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(_number_string, 0) do
    1
  end

  def largest_product(number_string, size) when byte_size(number_string) < size or size < 0 do
    raise ArgumentError
  end

  def largest_product(number_string, size) do
    number_list =
      number_string
      |> String.to_charlist()
      |> Enum.map(&(&1 - ?0))

    {l1, l2} = number_list |> Enum.split(size)
    largest_product(l1, l2, size, 0)
  end

  defp largest_product(l, [], _s, m) do
    p = do_product(l)
    max(p, m)
  end

  defp largest_product(l = [_h | t1], [h | t2], s, m) do
    p = do_product(l)
    largest_product(t1 ++ [h], t2, s, max(p, m))
  end

  defp do_product(l) do
    l |> Enum.reduce(1, &(&1 * &2))
  end
end

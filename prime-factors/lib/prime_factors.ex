defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number) when number > 1 do
    do_factors_for(number, 2..(trunc(:math.sqrt(number)) + 1) |> Enum.to_list(), [])
    |> Enum.reverse()
  end

  def factors_for(1) do
    []
  end

  defp do_factors_for(target, [candidate | candidtes], acc) when rem(target, candidate) == 0 do
    do_factors_for(div(target, candidate), [candidate | candidtes], [candidate | acc])
  end

  defp do_factors_for(target, [_candidate | candidtes], acc) do
    do_factors_for(target, candidtes, acc)
  end

  defp do_factors_for(1, [], acc) do
    acc
  end

  defp do_factors_for(target, [], acc) do
    [target | acc]
  end
end

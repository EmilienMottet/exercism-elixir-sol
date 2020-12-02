defmodule Palindromes do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1) do
    for x <- min_factor..max_factor,
        y <- min_factor..max_factor,
        Integer.to_string(x * y) == String.reverse(Integer.to_string(x * y)) do
      {x * y, [min(x, y), max(x, y)]}
    end
    |> Stream.uniq_by(fn {_k, v} -> v end)
    |> Enum.group_by(fn {k, _v} -> k end, fn {_k, v} -> v end)
  end
end

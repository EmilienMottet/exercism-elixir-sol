defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    do_sieve(2..limit |> Enum.to_list, [])
  end

  defp do_sieve([], primes) do
    primes |> Enum.reverse()
  end

  defp do_sieve([prime | tail], primes) do
    new_tail = tail |> Enum.filter(fn x -> rem(x, prime) != 0 end)
    do_sieve(new_tail, [prime | primes])
  end
end

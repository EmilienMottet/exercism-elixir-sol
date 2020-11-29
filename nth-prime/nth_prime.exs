defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when count > 0 do
    Stream.iterate(2, &(&1 + 1))
    |> Enum.reduce_while(count, fn x, acc ->
      if is_prime(x) do
        acc = acc - 1

        if acc <= 0 do
          {:halt, x}
        else
          {:cont, acc}
        end
      else
        {:cont, acc}
      end
    end)
  end

  defp is_prime(n) do
    l = 2..n |> Enum.to_list() |> Enum.reverse() |> tl() |> Enum.reverse()
    [] == l || l |> Enum.all?(fn x -> rem(n, x) != 0 end)
  end
end

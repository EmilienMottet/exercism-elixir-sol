defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino] | []) :: boolean
  def chain?([]) do
    true
  end

  def chain?([first | dominoes]) do
    do_chain?({first, first}, dominoes)
  end

  defp do_chain?({{a, _}, {_, a}}, []), do: true

  defp do_chain?(_, []), do: false

  defp do_chain?({first, {_, d}}, dominoes) do
    dominoes
    |> Enum.any?(fn
      next = {^d, _} -> do_chain?({first, next}, List.delete(dominoes, next))
      next = {x, ^d} -> do_chain?({first, {d, x}}, List.delete(dominoes, next))
      _ -> false
    end)
  end
end

defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(_coins, 0) do
    {:ok, []}
  end

  def generate(coins, target) do
    coins = coins |> Enum.sort()
    posibilities = Map.new(coins, fn coin -> {coin, [coin]} end)

    do_generate(coins, target, posibilities, Map.get(posibilities, target, []))
  end

  def do_generate(_, _, posibilities, _) when map_size(posibilities) == 0 do
    {:error, "cannot change"}
  end

  def do_generate(coins, target, posibilities, []) do
    posibilities =
      posibilities
      |> Enum.flat_map(fn {total, posibility} ->
        coins
        |> Enum.flat_map(fn
          coin when total + coin <= target ->
            [{total + coin, [coin | posibility]}]

          _ ->
            []
        end)
      end)
      |> Map.new()

    do_generate(coins, target, posibilities, Map.get(posibilities, target, []))
  end

  def do_generate(_, _, _, changes), do: {:ok, changes |> Enum.sort()}
end

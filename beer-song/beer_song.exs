defmodule BeerSong do
  defp numero(0) do
    "No more"
  end

  defp numero(number) do
    rem(number + 100, 100)
  end

  defp bottle_s(1) do
    "bottle"
  end

  defp bottle_s(_) do
    "bottles"
  end

  defp bottle(number) do
    "#{numero(number)} #{bottle_s(number)}"
  end

  defp the_bottle(1) do
    "it"
  end

  defp the_bottle(_) do
    "one"
  end

  defp what_do_you_do(0) do
    "Go to the store and buy some more"
  end

  defp what_do_you_do(number) do
    "Take #{the_bottle(number)} down and pass it around"
  end

  @doc """
  Get a single verse of the beer song
  """

  @spec verse(integer) :: String.t()
  def verse(number) do
    """
    #{bottle(number)} of beer on the wall, #{String.downcase(bottle(number))} of beer.
    #{what_do_you_do(number)}, #{String.downcase(bottle(number - 1))} of beer on the wall.
    """
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..0) do
    range
    |> Enum.map_join("\n",fn x ->
      verse(x)
    end)
  end
end

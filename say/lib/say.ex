defmodule Say do
  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number) when number >= 0 and number < 1_000_000_000_000 do
    {:ok, do_in_english(number)}
  end

  def in_english(_) do
    {:error, "number is out of range"}
  end

  defp do_in_english(80) do
    "eighty"
  end

  defp do_in_english(50) do
    "fifty"
  end

  defp do_in_english(40) do
    "forty"
  end

  defp do_in_english(30) do
    "thirty"
  end

  defp do_in_english(20) do
    "twenty"
  end

  defp do_in_english(14) do
    "fourteen"
  end

  defp do_in_english(12) do
    "twelve"
  end

  defp do_in_english(9) do
    "nine"
  end

  defp do_in_english(7) do
    "seven"
  end

  defp do_in_english(6) do
    "six"
  end

  defp do_in_english(5) do
    "five"
  end

  defp do_in_english(4) do
    "four"
  end

  defp do_in_english(3) do
    "three"
  end

  defp do_in_english(2) do
    "two"
  end

  defp do_in_english(1) do
    "one"
  end

  defp do_in_english(0) do
    "zero"
  end

  defp do_in_english(number) when rem(number, 1_000_000_000) == 0 do
    "#{do_in_english(div(number, 1_000_000_000))} billion"
  end

  defp do_in_english(number) when rem(number, 1_000_000) == 0 do
    "#{do_in_english(div(number, 1_000_000))} million"
  end

  defp do_in_english(number) when rem(number, 1_000) == 0 do
    "#{do_in_english(div(number, 1_000))} thousand"
  end

  defp do_in_english(number) when rem(number, 100) == 0 do
    "#{do_in_english(div(number, 100))} hundred"
  end

  defp do_in_english(number) when number > 1_000_000_000 do
    "#{do_in_english(number - rem(number, 1_000_000_000))} #{
      do_in_english(rem(number, 1_000_000_000))
    }"
  end

  defp do_in_english(number) when number > 1_000_000 do
    "#{do_in_english(number - rem(number, 1_000_000))} #{do_in_english(rem(number, 1_000_000))}"
  end

  defp do_in_english(number) when number > 1_000 do
    "#{do_in_english(number - rem(number, 1_000))} #{do_in_english(rem(number, 1_000))}"
  end

  defp do_in_english(number) when number > 100 do
    "#{do_in_english(number - rem(number, 100))} #{do_in_english(rem(number, 100))}"
  end

  defp do_in_english(number) when number > 20 do
    "#{do_in_english(number - rem(number, 10))}-#{do_in_english(rem(number, 10))}"
  end
end

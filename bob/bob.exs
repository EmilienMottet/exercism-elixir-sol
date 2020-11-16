defmodule Bob do
  def hey(input) do
    cond do
      silence?(input) -> "Fine. Be that way!"
      shooting_asking?(input) -> "Calm down, I know what I'm doing!"
      shooting?(input) -> "Whoa, chill out!"
      asking?(input) -> "Sure."
      true -> "Whatever."
    end
  end

  defp shooting?(input) do
    String.upcase(input) == input && String.downcase(input) != input
  end
  defp asking?(input) do
    String.last(input)  == "?"
  end
  defp silence?(input) do
    String.trim(input) == ""
  end
  defp shooting_asking?(input) do
    shooting?(input) and asking?(input)
  end
end

defmodule TwelveDays do
  @ordinal [
    "first",
    "second",
    "third",
    "fourth",
    "fifth",
    "sixth",
    "seventh",
    "eighth",
    "ninth",
    "tenth",
    "eleventh",
    "twelfth"
  ]

  @verse [
    "and a Partridge in a Pear Tree.",
    "two Turtle Doves",
    "three French Hens",
    "four Calling Birds",
    "five Gold Rings",
    "six Geese-a-Laying",
    "seven Swans-a-Swimming",
    "eight Maids-a-Milking",
    "nine Ladies Dancing",
    "ten Lords-a-Leaping",
    "eleven Pipers Piping",
    "twelve Drummers Drumming"
  ]

  def sing do
    verses(1, 12)
  end

  def verse(1) do
    build_verse(0, "a Partridge in a Pear Tree.")
  end

  def verse(num_verse) do
    end_sentence = @verse |> Enum.take(num_verse) |> Enum.reverse() |> Enum.join(", ")
    build_verse(num_verse - 1, end_sentence)
  end

  def verses(begin_verse, end_verse) do
    begin_verse..end_verse |> Enum.map(&verse/1) |> Enum.join("\n")
  end

  defp build_verse(num, end_sentence) do
    "On the #{@ordinal |> Enum.at(num)} day of Christmas my true love gave to me: #{end_sentence}"
  end
end

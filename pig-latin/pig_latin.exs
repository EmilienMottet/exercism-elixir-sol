defmodule PigLatin do
  @vowel ["a", "e", "i", "o", "u", "yt", "yd", "xr", "xb"]

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(words) do
    words |> String.split() |> Enum.map(fn x -> translate_word(x) end) |> Enum.join(" ")
  end

  defp translate_word(word) do
    if rule1?(word) do
      rule_1(word)
    else
      if rule4?(word) do
        [begin_word, end_word] = word |> String.split("y", parts: 2)
        rule_4(end_word, begin_word)
      else
        if rule3?(word) do
          [begin_word, end_word] = word |> String.split("qu", parts: 2)
          rule_3(end_word, begin_word <> "qu")
        else
          {begin_word, end_word} =
            word |> String.codepoints() |> Enum.split_while(fn x -> x not in @vowel end)

          rule_2(end_word |> Enum.join(), begin_word |> Enum.join())
        end
      end
    end
  end

  defp rule1?(word) do
    word |> String.starts_with?(@vowel)
  end

  defp rule3?(word) do
    {_, end_word} = word |> String.split_at(1)
    word |> String.starts_with?("qu") || end_word |> String.starts_with?("qu")
  end

  defp rule4?(word) do
    {_, end_word} = word |> String.split_at(1)

    end_word |> String.contains?("y") &&
      word
      |> String.split("y", parts: 2)
      |> hd
      |> String.codepoints()
      |> Enum.all?(fn x -> x not in @vowel end)
  end

  defp rule_1(word) do
    word <> "ay"
  end

  defp rule_2(end_word, letters) do
    end_word <> letters <> "ay"
  end

  defp rule_3(end_word, letters) do
    rule_2(end_word, letters)
  end

  defp rule_4(end_word, letters) do
    rule_2("y" <> end_word, letters)
  end
end

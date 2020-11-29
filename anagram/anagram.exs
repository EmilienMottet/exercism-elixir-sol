defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    candidates
    |> Enum.filter(fn x ->
      test_anagram(x, base) && base |> String.downcase() != x |> String.downcase()
    end)
  end

  defp test_anagram(a, b) do
    a |> String.downcase() |> to_charlist |> Enum.sort() ==
      b |> String.downcase() |> to_charlist |> Enum.sort()
  end
end

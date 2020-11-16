defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    sentence = sentence |> String.downcase |> String.replace(["-","\s"],"")
    sentence |> String.codepoints |> Enum.uniq |> Enum.count == sentence |> String.length
  end
end

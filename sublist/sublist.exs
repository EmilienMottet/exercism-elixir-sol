defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, a) do
    :equal
  end

  def compare(a, b) when length(a) < length(b) do
    if String.contains?("-#{b |> Enum.join("-")}-", "-#{a |> Enum.join("-")}-") do
      :sublist
    else
      :unequal
    end
  end

  def compare(a, b) do
    if String.contains?("-#{a |> Enum.join("-")}-", "-#{b |> Enum.join("-")}-") do
      :superlist
    else
      :unequal
    end
  end
end

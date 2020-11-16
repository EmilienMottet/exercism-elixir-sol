defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    String.split(string, "", trim: true) |> count_letter |> Enum.join
  end

  defp count_letter([]) do
    [""]
  end

  defp count_letter([h | tail]) do
    { head_array , new_tail } = tail |> Enum.split_while(fn x -> x == h end)
    [ "#{print_number(head_array |> Enum.count)}#{h}" | count_letter(new_tail) ]
  end

  defp print_number(0) do
    ""
  end
  defp print_number(n) do
    n+1
  end

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    Regex.replace(~r/(\d+)([\p{L}\s])/, string, fn _, n, l -> String.duplicate(l, String.to_integer(n)) end)
  end

end

defmodule Binary do
  use Bitwise

  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t()) :: non_neg_integer
  def to_decimal(string) do
    array = string |> String.graphemes()

    if array
       |> Enum.all?(fn
         v when v in ["1", "0"] -> true
         _ -> false
       end) do
      array
      |> Enum.reverse()
      |> Stream.with_index()
      |> Enum.reduce(0, fn
        {"0", index}, acc -> acc
        {"1", index}, acc -> acc + (1 <<< index)
      end)
    else
      0
    end
  end
end

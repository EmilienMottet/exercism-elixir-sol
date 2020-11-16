defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    with clean_number when byte_size(clean_number) > 1 <- clean_number(number),
         sum when is_integer(sum) <-
           apply_doubling(
             byte_size(clean_number),
             clean_number |> String.graphemes() |> Enum.reverse(),
             0
           ) do
      rem(sum, 10) == 0
    else
      _ -> false
    end
  end

  defp clean_number(number) do
    number |> String.replace(" ", "")
  end

  defguardp is_string_integer(integer)
            when integer in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

  defp apply_doubling(_number_size, [h | _t], _acc) when not is_string_integer(h) do
    false
  end

  defp apply_doubling(number_size, arr = [h | t], acc)
       when is_string_integer(h) and rem(number_size - length(arr), 2) == 1 and h < "5" do
    apply_doubling(number_size, t, acc + String.to_integer(h) * 2)
  end

  defp apply_doubling(number_size, arr = [h | t], acc)
       when is_string_integer(h) and rem(number_size - length(arr), 2) == 1 and h >= "5" do
    apply_doubling(number_size, t, acc + String.to_integer(h) * 2 - 9)
  end

  defp apply_doubling(number_size, arr = [h | t], acc)
       when is_string_integer(h) and rem(number_size - length(arr), 2) == 0 do
    apply_doubling(number_size, t, acc + String.to_integer(h))
  end

  defp apply_doubling(_number_size, [], acc) do
    acc
  end
end

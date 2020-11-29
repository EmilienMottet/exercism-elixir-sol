defmodule Roman do

	@pow %{0 => "I", 1 => "X", 2 => "C", 3 => "M" }
	@pow5 %{0 => "V", 1 => "L", 2 => "D"}

  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t()
  def numerals(number) do
    0..3
    |> Enum.reverse
    |> Enum.map(fn pow ->
      r = rem(number,trunc(:math.pow(10,pow+1)));
      numerals(trunc(r/:math.pow(10,pow)) ,pow)
    end)
    |> Enum.join("")

  end

  # 0-3
  def numerals(number,pow) when number < 4 do
    String.duplicate(@pow[pow],number)
  end

  # 4
  def numerals(number,pow) when number < 5 do
    String.duplicate(@pow[pow],5 - number) <> @pow5[pow]
  end

  # 5-8
  def numerals(number, pow) when number < 9 do
    @pow5[pow] <> String.duplicate(@pow[pow],number - 5)
  end

  # 9
  def numerals(number, pow) when number < 10 do
    String.duplicate(@pow[pow],10 - number) <> @pow[pow+1]
  end

end

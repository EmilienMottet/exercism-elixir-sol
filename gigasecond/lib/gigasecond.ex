defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          :calendar.datetime()

  def from(erlang_date_time = {{_year, _month, _day}, {_hours, _minutes, _seconds}}) do
    gigasecond = :math.pow(10, 9) |> round
    erlang_date_time |> NaiveDateTime.from_erl!() |> NaiveDateTime.add(gigasecond) |> NaiveDateTime.to_erl()
  end
end

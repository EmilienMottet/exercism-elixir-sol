defmodule Meetup do
  @weekday [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
           |> Enum.with_index(1)

  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date()
  def meetup(year, month, weekday, schedule) do
    begin_day =
      case schedule do
        :teenth -> [day: 12]
        :first -> [day: 0]
        :second -> [day: 7]
        :third -> [day: 14]
        :fourth -> [day: 21]
        :last -> [month: 1, day: -1]
      end

    {:ok, date} = Date.new(year, month, 1)

    case begin_day do
      [month: 1, day: -1] ->
        d = Date.days_in_month(date) - 1
        date = Date.add(date, d)
        current_day = Date.day_of_week(date)
        add = rem(-@weekday[weekday] + 7 + current_day, 7)
        Date.add(date, -add)

      [day: d] ->
        date = Date.add(date, d)
        current_day = Date.day_of_week(date)
        add = rem(@weekday[weekday] + 7 - current_day, 7)
        Date.add(date, add)
    end
  end
end

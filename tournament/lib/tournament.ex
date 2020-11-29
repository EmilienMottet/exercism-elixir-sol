defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    input
    |> Stream.map(&parse/1)
    |> Enum.reduce(%{}, fn x, acc ->
      Map.merge(x, acc, fn _k, map1, map2 ->
        Map.merge(map1, map2, fn _k, v1, v2 -> v1 + v2 end)
      end)
    end)
    |> Stream.map(fn {k, v} ->
      {total, mp} =
        v
        |> Enum.reduce({0, 0}, fn
          {:l, ct}, {tot, mp} -> {tot + 0, mp + ct}
          {:d, ct}, {tot, mp} -> {tot + ct * 1, mp + ct}
          {:w, ct}, {tot, mp} -> {tot + ct * 3, mp + ct}
        end)

      {k,
       v
       |> Map.put(
         :total,
         total
       )
       |> Map.put(:mp, mp)}
    end)
    |> Enum.sort_by(fn {_team, %{total: t}} -> -t end)
    |> pretty_print()
  end

  def pretty_print(result) do
    header = "Team                           | MP |  W |  D |  L |  P"

    lines =
      result
      |> Enum.map(fn {team, score} ->
        String.pad_trailing(team, 31) <>
          "|  " <>
          "#{score[:mp] || 0}" <>
          " |  " <>
          "#{score[:w] || 0}" <>
          " |  " <>
          "#{score[:d] || 0}" <>
          " |  " <> "#{score[:l] || 0}" <> " |  " <> "#{score[:total] || 0}"
      end)
      |> Enum.join("\n")

    "#{header}\n#{lines}"
  end

  def parse(line) do
    case line |> String.split(";") do
      [team_1, team_2, "win"] ->
        %{team_1 => %{w: 1}, team_2 => %{l: 1}}

      [team_1, team_2, "loss"] ->
        %{team_1 => %{l: 1}, team_2 => %{w: 1}}

      [team_1, team_2, "draw"] ->
        %{team_1 => %{d: 1}, team_2 => %{d: 1}}

      _ ->
        %{}
    end
  end
end

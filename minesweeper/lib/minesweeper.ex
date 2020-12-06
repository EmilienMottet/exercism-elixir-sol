defmodule Minesweeper do
  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]

  def annotate(board) do
    board
    |> Stream.with_index()
    |> Stream.flat_map(fn {row, r_i} ->
      row
      |> String.graphemes()
      |> Stream.with_index()
      |> Enum.map(fn {tile, c_i} -> {{r_i, c_i}, tile} end)
    end)
    |> Enum.reduce(board |> Enum.map(fn row -> row |> String.graphemes() end), fn
      {{_r_i, _c_i}, " "}, board -> board
      {pos = {_r_i, _c_i}, "*"}, board -> increase_mine(board, pos)
    end)
    |> Enum.map(&Enum.join(&1))
  end

  defp generate_target_tiles({x, y}, max_row, max_col) do
    for xi <- -1..1,
        yi <- -1..1,
        not (xi == 0 and yi == 0),
        xi + x >= 0,
        yi + y >= 0,
        xi + x < max_row,
        yi + y < max_col do
      {xi + x, yi + y}
    end
  end

  defp increase_mine(board, p = {_x, _y}) do
    generate_target_tiles(p, length(board), length(hd(board)))
    |> Enum.reduce(board, fn {x, y}, board ->
      update_in(board, [Access.at(x)], fn row ->
        update_in(row, [Access.at(y)], fn
          " " -> "1"
          "*" -> "*"
          tile -> "#{String.to_integer(tile) + 1}"
        end)
      end)
    end)
  end
end

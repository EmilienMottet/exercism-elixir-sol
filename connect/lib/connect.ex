defmodule Connect do
  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """
  @spec result_for([String.t()]) :: :none | :black | :white
  def result_for(board) do
    map_board =
      board
      |> Stream.with_index()
      |> Stream.flat_map(fn {row, r_i} ->
        row
        |> String.graphemes()
        |> Stream.with_index()
        |> Stream.map(fn {tile, c_i} -> {{r_i, c_i}, tile} end)
        |> Stream.reject(fn {_p, color} -> color == "." end)
      end)
      |> Map.new()

    make_strings(map_board, length(board), String.length(hd(board)))
  end

  # def find_first_black(board) do
  #   board
  #   |> Enum.find(fn
  #     {_p, "O"} -> true
  #     {_p, tile} when tile in ["X", "."] -> false
  #   end)
  # end

  def make_strings(board, _r_size, _c_size) when map_size(board) == 0 do
    :none
  end

  def make_strings(board, r_size, c_size) do
    {p, color} = board |> Enum.to_list() |> hd()
    board = board |> Map.delete(p)
    str = [p]
    str_n = add_neighbour(board, r_size, c_size, p, color)
    str = str ++ str_n

    cond do
      is_to_from_bottom(str, r_size) and color == "O" ->
        :white

      is_to_left_right(str, c_size) and color == "X" ->
        :black

      true ->
        board = str_n |> Enum.reduce(board, fn pn, b -> Map.delete(b, pn) end)
        make_strings(board, r_size, c_size)
    end
  end

  defp is_to_left_right(str, size) do
    Enum.min_by(str, fn {_x, y} -> y end) |> elem(1) == 0 and
      Enum.max_by(str, fn {_x, y} -> y end) |> elem(1) == size - 1
  end

  defp is_to_from_bottom(str, size) do
    Enum.min_by(str, fn {x, _y} -> x end) |> elem(0) == 0 and
      Enum.max_by(str, fn {x, _y} -> x end) |> elem(0) == size - 1
  end

  defp add_neighbour(board, r_size, c_size, target, color) do
    {str_n, board} =
      generate_neighbour_tiles(target, r_size, c_size)
      |> Stream.filter(fn pn -> pn in (board |> Map.keys()) end)
      |> Enum.reduce(
        {[], board},
        fn pn, {str, board} ->
          if board[pn] == color do
            {[pn | str], board |> Map.delete(pn)}
          else
            {str, board}
          end
        end
      )

    case {str_n, board} do
      {[], _} ->
        []

      {str_n, board} ->
        (str_n |> Enum.flat_map(fn p -> add_neighbour(board, r_size, c_size, p, color) end)) ++
          str_n
    end
  end

  defp generate_neighbour_tiles({x, y}, max_row, max_col) do
    for xi <- -1..1,
        yi <- -1..1,
        xi != yi,
        not (xi == 0 and yi == 0),
        xi + x >= 0,
        yi + y >= 0,
        xi + x < max_row,
        yi + y < max_col do
      {xi + x, yi + y}
    end
  end
end

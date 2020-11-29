defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct [:white, :black]

  @min_index 0
  @max_index 7

  defp do_new([{color, pos = {x, y}} | t], acc)
  when color in [:black, :white] and x >= @min_index and x <= @max_index and y >= @min_index and
  y <= @max_index do
    queen = %{color => pos}

    merged =
      Map.merge(Map.from_struct(acc), queen, fn
        k, v, nil when k in [:black, :white] -> v
        k, nil, v when k in [:black, :white] -> v
      end)

    do_new(t, struct(Queens, merged))
  end

  defp do_new([], acc) do
    acc
  end

  defp do_new(_, _) do
    raise ArgumentError
  end

  @doc """
  Creates a new set of Queens
  """
  @spec new(Keyword.t()) :: Queens.t()
  def new(opts \\ []) do
    res = do_new(opts, %Queens{})

    case res do
      %Queens{black: pos, white: pos} -> raise ArgumentError
      res -> res
    end
  end

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    for x <- @min_index..@max_index, y <- @min_index..@max_index do
      cond do
        {x,y} == queens.black -> "B"
        {x,y} == queens.white -> "W"
        true -> "_"
      end
    end
    |> Enum.chunk_every(@max_index + 1)
    |> Enum.map(fn line -> line |> Enum.join(" ") end)
    |> Enum.join("\n")
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(queens) do
    case queens do
      %Queens{black: {x, _by}, white: {x, _wy}} -> true
      %Queens{black: {_bx, y}, white: {_wx, y}} -> true
      %Queens{black: {bx, by}, white: {wx, wy}} when abs(bx - wx) == abs(by - wy) -> true
      _ -> false
    end
  end
end

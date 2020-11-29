defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    str
    |> String.split("\n")
    |> Enum.map(fn line -> line |> String.split() |> Enum.map(&String.to_integer/1) end)
  end

  defp transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    rows(str) |> transpose()
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    rows = rows(str)
    columns = columns(str)

    indexes_max_per_row =
      rows
      |> Stream.with_index()
      |> Enum.flat_map(fn {row, r_i} ->
        max = row |> Enum.max()

        row
        |> Stream.with_index()
        |> Stream.filter(fn
          {^max, _index} -> true
          _ -> false
        end)
        |> Enum.map(fn {_v, c_i} -> {r_i, c_i} end)
      end)
      |> MapSet.new()

    indexes_min_per_column =
      columns
      |> Stream.with_index()
      |> Enum.flat_map(fn {column, c_i} ->
        min = column |> Enum.min()

        column
        |> Stream.with_index()
        |> Stream.filter(fn
          {^min, _index} -> true
          _ -> false
        end)
        |> Enum.map(fn {_v, r_i} -> {r_i, c_i} end)
      end)
      |> MapSet.new()

    MapSet.intersection(indexes_max_per_row, indexes_min_per_column) |> MapSet.to_list()
  end
end

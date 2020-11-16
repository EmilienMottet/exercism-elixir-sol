defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten([]) do
    []
  end
  def flatten([h | tail]) when is_list(h) do
    flatten(h) ++ flatten(tail)
  end
  def flatten([nil | tail]) do
    flatten(tail)
  end
  def flatten([h | tail]) do
    [h | flatten(tail)]
  end
end

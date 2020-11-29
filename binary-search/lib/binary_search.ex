defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) when is_tuple(numbers) do
    max = tuple_size(numbers) - 1
    do_search(numbers, key, 0, max)
  end

  defp do_search(_numbers, _key, min_index, max_index) when min_index > max_index do
    :not_found
  end

  defp do_search(numbers, key, min_index, max_index) when is_tuple(numbers) do
    index = div(min_index + max_index, 2)

    case elem(numbers, index) do
      ^key -> {:ok, index}
      target when target > key -> do_search(numbers, key, min_index, index - 1)
      target when target < key -> do_search(numbers, key, index + 1, max_index)
    end
  end
end

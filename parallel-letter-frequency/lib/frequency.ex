defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    texts
    |> Task.async_stream(
      fn text ->
        text
        |> String.downcase()
        |> String.graphemes()
        |> Stream.filter(fn
          x when (x >= "a" and x <= "z") or x in ["ü"] -> true
          _ -> false
        end)
        |> Enum.frequencies()
      end,
      max_concurrency: workers
    )
    |> Enum.reduce(%{}, fn {:ok, frequencies_map}, acc ->
      Map.merge(acc, frequencies_map, fn _key, v1, v2 -> v1 + v2 end)
    end)
  end
end

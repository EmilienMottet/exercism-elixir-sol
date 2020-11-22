defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) when number < 1 do
    {:error, "Classification is only possible for natural numbers."}
  end
  def classify(1) do
    {:ok, :deficient}
  end
  def classify(number) when is_integer(number) do
    aliquot_sum = 1..(div(number, 2)) |> Stream.filter(&(rem(number, &1) == 0)) |> Enum.sum()

    case aliquot_sum do
      ^number -> {:ok, :perfect}
      aliquot_sum when aliquot_sum > number -> {:ok, :abundant}
      aliquot_sum when aliquot_sum < number -> {:ok, :deficient}
    end
  end
end

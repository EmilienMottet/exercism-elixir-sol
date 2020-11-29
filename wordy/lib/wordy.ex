defmodule Wordy do
  @doc """
  Calculate the math problem in the sentence.
  """
  @spec answer(String.t()) :: integer
  def answer(question) do
    case extract_number(question) do
      {tail, number} ->
        calculate(tail, number)

      :no_number ->
        raise ArgumentError
    end
  end

  defp extract_operator(str) do
    cond do
      match = Regex.run(~r/^\D+plus/, str, return: :index) ->
        [{index, len}] = match
        {String.slice(str, (index + len)..-1), &Kernel.+/2}

      match = Regex.run(~r/^\D+minus/, str, return: :index) ->
        [{index, len}] = match
        {String.slice(str, (index + len)..-1), &Kernel.-/2}

      match = Regex.run(~r/^\D+multiplied/, str, return: :index) ->
        [{index, len}] = match
        {String.slice(str, (index + len)..-1), &Kernel.*/2}

      match = Regex.run(~r/^\D+divided/, str, return: :index) ->
        [{index, len}] = match
        {String.slice(str, (index + len)..-1), &Kernel.//2}

      "?" == str ->
        :end

      true ->
        :unknown_operator
    end
  end

  defp extract_number(str) do
    case Regex.run(~r/-?\d+/, str, return: :index) do
      [{index, len}] ->
        {String.slice(str, (index + len)..-1),
         String.slice(str, index, len) |> String.to_integer()}

      _ ->
        :no_number
    end
  end

  defp calculate(str, acc) do
    with {str, f} <- extract_operator(str),
         {str, number} <- extract_number(str) do
      calculate(str, f.(acc, number))
    else
      err when err in [:unknown_operator, :no_number] -> raise ArgumentError
      :end -> acc
    end
  end
end

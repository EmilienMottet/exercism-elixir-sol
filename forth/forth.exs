defmodule Forth do
  @opaque evaluator :: %Forth{}
  defstruct stack: [], definitions: %{}

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    %Forth{}
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    s
    |> String.split(~r/[\pC\pZ]+/u)
    |> parser()
    |> eval_expr(ev)
  end

  defp parser(word_list) do
    word_list
    |> Enum.map(fn
      "+" ->
        &Kernel.+/2

      "-" ->
        &Kernel.-/2

      "*" ->
        &Kernel.*/2

      "/" ->
        fn
          _, 0 -> raise Forth.DivisionByZero
          x, y -> Kernel.div(x, y)
        end

      x ->
        case Integer.parse(x) do
          {i, _} ->
            i

          :error ->
            String.upcase(x)
        end
    end)
    |> List.flatten()
  end

  defp eval_expr([], ev) do
    ev
  end

  defp eval_expr([function | tail_expr], forth = %Forth{stack: [h1, h2 | tail_stack]})
       when is_function(function, 2) do
    eval_expr(tail_expr, %Forth{forth | stack: [function.(h2, h1) | tail_stack]})
  end

  defp eval_expr([integer | tail], forth = %Forth{stack: stack}) when is_integer(integer) do
    eval_expr(tail, %Forth{forth | stack: [integer | stack]})
  end

  defp eval_expr([":", definition | tail], forth = %Forth{definitions: definitions})
       when is_bitstring(definition) do
    {definition_value, [_ | new_tail]} =
      tail
      |> Enum.split_while(fn
        ";" -> false
        _ -> true
      end)

    eval_expr(new_tail, %Forth{
      forth
      | definitions: put_in(definitions, [definition], definition_value)
    })
  end

  defp eval_expr([":" | _], _) do
    raise Forth.InvalidWord
  end

  defp eval_expr(words = [instruction | tail], forth = %Forth{definitions: definitions})
       when is_bitstring(instruction) do
    case Map.fetch(definitions, instruction) do
      {:ok, value} ->
        eval_expr([value | tail] |> List.flatten(), forth)

      :error ->
        eval_atom(words, forth)
    end
  end

  defp eval_atom(["DUP" | _], %Forth{stack: []}) do
    raise Forth.StackUnderflow
  end

  defp eval_atom(["DROP" | _], %Forth{stack: []}) do
    raise Forth.StackUnderflow
  end

  defp eval_atom(["SWAP" | _], %Forth{stack: []}) do
    raise Forth.StackUnderflow
  end

  defp eval_atom(["SWAP" | _], %Forth{stack: [_]}) do
    raise Forth.StackUnderflow
  end

  defp eval_atom(["OVER" | _], %Forth{stack: []}) do
    raise Forth.StackUnderflow
  end

  defp eval_atom(["OVER" | _], %Forth{stack: [_]}) do
    raise Forth.StackUnderflow
  end

  defp eval_atom(["DUP" | tail], forth = %Forth{stack: [head | tail_stack]}) do
    eval_expr(tail, %Forth{forth | stack: [head, head | tail_stack]})
  end

  defp eval_atom(["DROP" | tail], forth = %Forth{stack: [_ | tail_stack]}) do
    eval_expr(tail, %Forth{forth | stack: tail_stack})
  end

  defp eval_atom(["SWAP" | tail], forth = %Forth{stack: [h1, h2 | tail_stack]}) do
    eval_expr(tail, %Forth{forth | stack: [h2, h1 | tail_stack]})
  end

  defp eval_atom(["OVER" | tail], forth = %Forth{stack: [_, h2 | _] = stack}) do
    eval_expr(tail, %Forth{forth | stack: [h2 | stack]})
  end

  defp eval_atom(_, _) do
    raise Forth.UnknownWord
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(%Forth{stack: stack}) do
    stack |> Enum.reverse() |> Enum.join(" ")
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end

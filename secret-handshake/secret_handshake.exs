defmodule SecretHandshake do
  use Bitwise

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    tester = [
      {fn x -> (x &&& 1) == 1 end, "wink"},
      {fn x -> (x &&& 2) == 2 end, "double blink"},
      {fn x -> (x &&& 4) == 4 end, "close your eyes"},
      {fn x -> (x &&& 8) == 8 end, "jump"}
    ]

    res =
      tester
      |> Enum.reduce([], fn {f, action}, acc ->
        if f.(code) do
          [action | acc]
        else
          acc
        end
      end)

    if (code &&& 16) == 16 do
      res
    else
      res |> Enum.reverse()
    end
  end
end

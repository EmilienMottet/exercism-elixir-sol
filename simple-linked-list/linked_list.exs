defmodule LinkedList do
  @opaque t :: tuple()

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new() do
    {}
  end

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(list, elem) do
    {elem, list}
  end

  @doc """
  Calculate the length of a LinkedList
  """
  @spec length(t) :: non_neg_integer()
  def length(list) do
    list |> length(0)
  end

  defp length({}, ct) do
    ct
  end

  defp length({_, list}, ct) do
    length(list, ct + 1)
  end

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?({}) do
    true
  end

  def empty?(_) do
    false
  end

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek({}) do
    {:error, :empty_list}
  end

  def peek({val, _}) do
    {:ok, val}
  end

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail({}) do
    {:error, :empty_list}
  end

  def tail({_, list}) do
    {:ok, list}
  end

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop({}) do
    {:error, :empty_list}
  end

  def pop({a, list}) do
    {:ok, a, list}
  end

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list(list) do
    list |> Enum.reverse() |> Enum.reduce(new(), fn x, acc -> push(acc, x) end)
  end

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list(list) do
    list |> to_list([]) |> Enum.reverse()
  end

  defp to_list({}, acc) do
    acc
  end

  defp to_list({a, list}, acc) do
    to_list(list, [a | acc])
  end

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list) do
    reverse(list, new())
  end

  defp reverse({}, new) do
    new
  end

  defp reverse({a, list}, new) do
    reverse(list, {a, new})
  end
end

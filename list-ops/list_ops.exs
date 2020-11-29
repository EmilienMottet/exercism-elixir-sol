defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer

  defp count([], c) do
    c
  end

  defp count([_ | t], c) do
    count(t, c + 1)
  end

  def count(l) do
    count(l, 0)
  end

  defp reverse([], r) do
    r
  end

  defp reverse([h | t], r) do
    reverse(t, [h | r])
  end

  @spec reverse(list) :: list
  def reverse(l) do
    reverse(l, [])
  end

  @spec map(list, (any -> any)) :: list
  def map(l, f) do
    for n <- l, do: f.(n)
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
    for n <- l, f.(n), do: n
  end

  defp reduce_r([], acc, _f) do
    acc
  end

  defp reduce_r([h | t], acc, f) do
    reduce_r(t, f.(h, acc), f)
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce(l, acc, f) do
    reduce_r(l, acc, f)
  end

  defp prepend([], list) do
    list
  end

  defp prepend([h | t], list) do
    prepend(t, [h | list])
  end

  @spec append(list, list) :: list
  def append(a, b) do
    prepend(reverse(a), b)
  end

  @spec concat([[any]]) :: [any]
  def concat(ll) do
    reverse(ll) |> reduce([], &(append(&1, &2)))
  end
end

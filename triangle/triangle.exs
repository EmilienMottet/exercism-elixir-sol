defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  defguardp inequality(a, b, c) when a < b + c and b < a + c and c < a + b
  defguardp positive(a, b, c) when a > 0 and b > 0 and c > 0

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) when not positive(a, b, c) do
    {:error, "all side lengths must be positive"}
  end

  def kind(a, b, c) when not inequality(a, b, c) do
    {:error, "side lengths violate triangle inequality"}
  end

  def kind(a, a, a) do
    {:ok, :equilateral}
  end

  def kind(a, a, _) do
    {:ok, :isosceles}
  end

  def kind(a, _, a) do
    {:ok, :isosceles}
  end

  def kind(_, a, a) do
    {:ok, :isosceles}
  end
  def kind(_, _, _) do
    {:ok, :scalene}
  end
end

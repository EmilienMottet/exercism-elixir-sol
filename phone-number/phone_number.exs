defmodule Phone do
  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("212-555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 055-0100")
  "0000000000"

  iex> Phone.number("(212) 555-0100")
  "2125550100"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @spec number(String.t()) :: String.t()
  def number(raw) do
    if Regex.match?(~r/[a-zA-Z]/, raw) do
      "0000000000"
    else
      n = raw |> String.replace(~r/[^\d]/, "")

      n = extract_ten(n)

      if valid_n(n) do
        n
      else
        "0000000000"
      end
    end
  end

  defp extract_ten(string_with_number) do
    if string_with_number |> String.length() == 11 && string_with_number |> String.first() == "1" do
      string_with_number |> String.slice(1..-1)
    else
      if string_with_number |> String.length() == 10 do
        string_with_number
      else
        "0000000000"
      end
    end
  end

  defp valid_n(n) do
    n |> String.at(0) |> String.to_integer() > 1 && n |> String.at(3) |> String.to_integer() > 1
  end

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("212-555-0100")
  "212"

  iex> Phone.area_code("+1 (212) 555-0100")
  "212"

  iex> Phone.area_code("+1 (012) 555-0100")
  "000"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t()) :: String.t()
  def area_code(raw) do
    number(raw) |> String.slice(0,3)
  end

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("212-555-0100")
  "(212) 555-0100"

  iex> Phone.pretty("212-155-0100")
  "(000) 000-0000"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t()) :: String.t()
  def pretty(raw) do
    n = number(raw)
    "(#{area_code(raw)}) #{String.slice(n,3,3)}-#{String.slice(n,6,4)}"
  end
end

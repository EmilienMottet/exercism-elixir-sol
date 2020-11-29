defmodule Garden do
  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @spec info(String.t(), list) :: map
  def info(
        info_string,
    student_names \\ [:larry, :kincaid, :joseph, :ileana, :harriet, :ginny, :fred, :eve, :david,
                      :charlie, :bob, :alice]
      ) do
    [line1, line2] =
      info_string |> String.split("\n") |> Enum.map(fn l -> l |> String.codepoints() end)

    cups =
      Enum.zip(line1, line2)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [{v1, v3}, {v2, v4}] -> [v1, v2, v3, v4] end)
    
    student_names = student_names |> Enum.sort()

    acc = student_names |> Enum.reduce(%{}, fn n, acc -> Map.put(acc, n, {}) end)

    z = Enum.zip(student_names, cups)

    z
    |> Enum.reduce(acc, fn {name, letters}, acc ->
      [v1, v2, v3, v4] =
        letters
        |> Enum.map(fn letter ->
          case letter do
            "R" -> :radishes
            "C" -> :clover
            "G" -> :grass
            "V" -> :violets
          end
        end)

      %{acc | name => {v1, v2, v3, v4}}
    end)
  end
end

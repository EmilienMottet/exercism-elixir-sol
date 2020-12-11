defmodule Dot do
  require Graph

  def parse_lines([], %Graph{
        attrs: attrs,
        nodes: nodes,
        edges: edges
      }) do
    %Graph{
      attrs: attrs |> Enum.sort(),
      nodes: nodes |> Enum.sort(),
      edges: edges |> Enum.sort()
    }
  end

  def parse_lines([{:--, _line_number, [{node_a, _, nil}, {node_b, _, attr}]} | lines], %Graph{
        attrs: attrs,
        nodes: nodes,
        edges: edges
      }) do
    attr =
      case attr do
        nil -> []
        [a = [{_k, _v}]] when is_list(a) -> a
        [a = []] -> a
        _ -> raise ArgumentError
      end

    parse_lines(lines, %Graph{attrs: attrs, nodes: nodes, edges: [{node_a, node_b, attr} | edges]})
  end

  def parse_lines([{:graph, _line_number, [attr]} | lines], %Graph{
        attrs: attrs,
        nodes: nodes,
        edges: edges
      }) do
    parse_lines(lines, %Graph{attrs: attr ++ attrs, nodes: nodes, edges: edges})
  end

  def parse_lines([{node, _line_number, attr} | lines], %Graph{
        attrs: attrs,
        nodes: nodes,
        edges: edges
      })
      when node != :graph and is_atom(node) do
    attr =
      case attr do
        nil -> []
        [a = [{_k, _v}]] when is_list(a) -> a
        [a = []] -> a
        _ -> raise ArgumentError
      end

    parse_lines(lines, %Graph{attrs: attrs, nodes: [{node, attr} | nodes], edges: edges})
  end

  def parse_lines(_, _) do
    raise ArgumentError
  end

  defmacro graph(do: block) do
    lines =
      case block do
        {:__block__, _lines_number, lines} -> lines
        line -> [line]
      end

    Macro.escape(parse_lines(lines, %Graph{attrs: [], nodes: [], edges: []}))
  end
end

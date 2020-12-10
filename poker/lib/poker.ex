defmodule Poker do
  @doc """
  Given a list of poker hands, return a list containing the highest scoring hand.

  If two or more hands tie, return the list of tied hands in the order they were received.

  The basic rules and hand rankings for Poker can be found at:

  https://en.wikipedia.org/wiki/List_of_poker_hands

  For this exercise, we'll consider the game to be using no Jokers,
  so five-of-a-kind hands will not be tested. We will also consider
  the game to be using multiple decks, so it is possible for multiple
  players to have identical cards.

  Aces can be used in low (A 2 3 4 5) or high (10 J Q K A) straights, but do not count as
  a high card in the former case.

  For example, (A 2 3 4 5) will lose to (2 3 4 5 6).

  You can also assume all inputs will be valid, and do not need to perform error checking
  when parsing card values. All hands will be a list of 5 strings, containing a number
  (or letter) for the rank, followed by the suit.

  Ranks (lowest to highest): 2 3 4 5 6 7 8 9 10 J Q K A
  Suits (order doesn't matter): C D H S

  Example hand: ~w(4S 5H 4C 5D 4H) # Full house, 5s over 4s
  """

  @ranks ~w(2 3 4 5 6 7 8 9 10 J Q K A)
         |> Stream.with_index()
         |> Map.new()

  @spec best_hand(list(list(String.t()))) :: list(list(String.t()))
  def best_hand(hands) do
    stream_hands =
      hands
      |> Stream.map(fn hand ->
        format_hand(hand)
      end)

    max =
      stream_hands
      |> Enum.max_by(fn hand -> identify_hand(hand) end)

    stream_hands
    |> Enum.filter(fn hand -> identify_hand(hand) == identify_hand(max) end)
    |> Enum.map(&(&1 |> Enum.map(fn {rank, color} -> "#{rank}#{color}" end)))
  end

  def identify_hand(hand) do
    cond do
      res = straight_flush(hand) -> res
      res = four(hand) -> res
      res = full_house(hand) -> res
      res = flush(hand) -> res
      res = straight(hand) -> res
      res = three(hand) -> res
      res = two_pairs(hand) -> res
      res = pairs(hand) -> res
      res = highest_card(hand) -> res
    end
  end

  def straight_flush(hand) do
    case {flush(hand), straight(hand)} do
      {{6, _}, {s, _}} when s in [4, 5] -> {9, sort_rest_by_rank(hand)}
      _ -> nil
    end
  end

  def four(hand) do
    rank = find_n_same(hand, 4)

    if rank == [] do
      nil
    else
      last_card =
        [_card] =
        hand
        |> sort_rest_by_rank(hand |> Enum.filter(fn {r, _color} -> r in rank end))

      {8, {rank, last_card}}
    end
  end

  def full_house(hand) do
    case {three(hand), pairs(hand)} do
      {{3, {three_rank, _three_rest}}, {1, {pair_rank, _pair_rest}}} ->
        {7, {three_rank, pair_rank}}

      _ ->
        nil
    end
  end

  def flush(hand = [{_hr, hc} | _]) do
    if not Enum.all?(hand, fn {_rank, color} -> color == hc end) do
      nil
    else
      {6, sort_rest_by_rank(hand)}
    end
  end

  def straight(hand) do
    sorted_by_rank =
      hand
      |> sort_rest_by_rank()

    if not (sorted_by_rank
            |> Stream.with_index()
            |> Enum.all?(fn
              # 0 start by Ace and follow by 2, 9 start by 10
              {"A", 4} -> @ranks[hd(sorted_by_rank)] in [0, 8]
              {r, i} -> @ranks[r] - i == @ranks[hd(sorted_by_rank)]
            end)) do
      nil
    else
      case sorted_by_rank do
        ["2", a, b, c, "A"] -> {4, ["A", "2", a, b, c]}
        _ -> {5, sorted_by_rank}
      end
    end
  end

  def three(hand) do
    rank = find_n_same(hand, 3)

    if rank == [] do
      nil
    else
      rest =
        hand
        |> sort_rest_by_rank(hand |> Enum.filter(fn {r, _color} -> r in rank end))

      {3, {rank, rest}}
    end
  end

  def two_pairs(hand) do
    case pairs(hand) do
      {1, {rank, _rest}} when length(rank) == 2 ->
        last_card =
          [_card] =
          hand
          |> sort_rest_by_rank(hand |> Enum.filter(fn {r, _color} -> r in rank end))

        {2, {rank |> Enum.sort(:desc), last_card}}

      _ ->
        nil
    end
  end

  def find_n_same(hand, n) do
    hand
    |> Enum.group_by(fn {rank, _color} -> rank end)
    |> Stream.map(fn {rank, cards} -> {rank, length(cards)} end)
    |> Stream.filter(fn {_rank, ct} -> ct == n end)
    |> Stream.map(fn {rank, _ct} -> rank end)
    |> Enum.sort()
  end

  def pairs(hand) do
    rank = find_n_same(hand, 2)

    if rank == [] do
      nil
    else
      rest =
        hand
        |> sort_rest_by_rank(hand |> Enum.filter(fn {r, _color} -> r in rank end))

      {1, {rank, rest}}
    end
  end

  def sort_rest_by_rank(hand, used_cards \\ []) do
    hand
    |> Stream.filter(fn card -> card not in used_cards end)
    |> Stream.map(fn {rank, _color} -> rank end)
    |> Enum.sort_by(&@ranks[&1])
  end

  def highest_card(hand) do
    rank = sort_rest_by_rank(hand)
    {0, rank}
  end

  def format_hand(hand) do
    hand
    |> Enum.map(fn card ->
      <<color::binary-size(1), rank::binary>> = card |> String.reverse()
      {rank |> String.reverse(), color}
    end)
  end
end

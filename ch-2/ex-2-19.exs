defmodule Con do
  def cons(x, y) do
    fn (f) -> f.(x, y) end
  end

  def car(c) do
    c.(fn (x, _y) -> x end)
  end

  def cdr(c) do
    c.(fn(_x, y) -> y end)
  end

end

defmodule MyList do
  import Con

  # To create a list using cons
  # from Elixir List
  def list([h | []]), do: cons(h, nil)
  def list([h | t]), do: cons(h, list(t))
  # list([1,2,3])
  # -> cons(1, list([2,3])
  # -> cons(1, cons(2, list[3]))
  # -. cons(1, cons(2, cons(3, nil))

  def each(nil, _f), do: :ok# nothing
  def each(list, f) do
    f.(car(list))
    each(cdr(list), f)
  end

  def print_list(list) do
    each(list, fn (n) -> IO.write("#{n} ") end)
    IO.puts ""
  end

  def list_ref(items, n) do
    if n == 0 do
      car(items)
    else
      list_ref(
        cdr(items),
        n - 1
      )
    end
  end

  def len(nil), do: 0
  def len(list) do
    len(cdr(list)) + 1
  end

  def reverse(list) do
    head = car(list)
    tail = cdr(list)
    reverse(tail, cons(head, nil))
  end
  def reverse(list, new_list) do
    head = car(list)
    tail = cdr(list)
    cond do
      tail == nil -> cons(head, new_list)
      true -> reverse(tail, cons(head, new_list))
    end
  end

  def no_more(coin_values) do
    len(coin_values) == 0
  end

  def except_first_denomination(coin_values) do
    cdr(coin_values)
  end

  def first_denomination(coin_values) do
    car(coin_values)
  end

  def cc(amount, coin_values) do
    cond do
      amount == 0 -> 1
      amount < 0 || no_more(coin_values) -> 0
      true ->
        cc(amount, except_first_denomination(coin_values)) +
          cc(amount - first_denomination(coin_values), coin_values)
    end
  end
end

us_coins = MyList.list([50, 25, 10, 5, 1])
reversed_us_coins = MyList.reverse(us_coins)
_uk_coins = MyList.list([100, 50, 20, 10, 2, 1, 0.5])

MyList.cc(100, us_coins) |> IO.inspect
MyList.cc(100, reversed_us_coins) |> IO.inspect



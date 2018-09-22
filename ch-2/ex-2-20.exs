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

  # We assumed a list args since
  # Elixir does not support abitrary
  # numbers of arguments,
  # at least in Elixir 1.7.3
  def same_parity(list) do
    first = car(list)
    is_even = fn (x) -> rem(x, 2) == 0 end
    is_odd = fn (x) -> rem(x, 2) != 0 end

    f = if is_even.(first) do
      is_even
    else
      is_odd
    end
    cons(first, same_parity(cdr(list), f))
  end
  def same_parity(list, f) do
    head = car(list)
    tail = cdr(list)

    cond do
      tail == nil -> nil
      f.(head) -> cons(head, same_parity(tail, f))
      true -> same_parity(tail, f)
    end
  end

end

odd = MyList.list([1,2,3,4,5,6,7])
even = MyList.list([2,3,4,5,6,7])

MyList.same_parity(odd) |> MyList.print_list()
MyList.same_parity(even) |> MyList.print_list()


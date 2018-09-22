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

# c = Con.cons(1, 2)
# Con.car(c) |> IO.inspect
# Con.cdr(c) |> IO.inspect

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

  def append(list1, list2) do
    cond do
      list1 == nil -> list2
      true ->
        cons(
          car(list1),
          append(
            cdr(list1),
            list2
          )
        )
    end
  end

  def last_pair(list) do
    tail = cdr(list)
    cond do
      tail == nil -> car(list)
      true -> last_pair(tail)
    end
  end
end

list = MyList.list([1,3,5,7])
MyList.last_pair(list) |> IO.inspect

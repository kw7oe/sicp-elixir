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

  def for_each(nil, _f), do: :ok# nothing
  def for_each(list, f) do
    f.(car(list))
    for_each(cdr(list), f)
  end

  def print(list) do
    print_list(list)
    IO.puts ""
  end
  def print_list(list) do
    print = fn (n) -> IO.write("#{n} ") end

    for_each(list, fn (n) ->
      if pair(n) do
        print_list(n)
      else
        print.(n)
      end
    end)
  end

  def pair(list), do: is_function(list)

  def fringe(list) do
    left = car(list)
    right = cdr(list)

    cond do
      right == nil -> list
      pair(left) ->
        cons(fringe(left), fringe(right))
      true -> cons(left, fringe(right))
    end
  end

end

list1 = MyList.list([1,2])
list2 = MyList.list([3,4])
list3 = MyList.list([list1, list2])
MyList.fringe(list3) |> MyList.print
MyList.fringe(MyList.list([list3, list3])) |> MyList.print


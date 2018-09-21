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
end

list = MyList.list([1,2,3])
MyList.print_list(list)
MyList.list_ref(list, 2) |> IO.inspect
MyList.len(list) |> IO.inspect

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

  def list([h | []]), do: cons(h, nil)
  def list([h | t]), do: cons(h, list(t))

  def pair?(list) when is_function(list), do: true
  def pair?(_list), do: false

  def for_each(nil, _f), do: :ok # nothing
  def for_each(list, f)  do
    cond do
      pair?(list) ->
        for_each(car(list), f)
        for_each(cdr(list), f)
      true ->
        f.(list)
    end
  end

  # Recursive
  def map(_, nil), do: nil
  def map(f, tree) do
    cons(
      f.(car(tree)),
      map(f, cdr(tree))
    )
  end

  def tree_map(_, nil), do: nil
  def tree_map(f, tree) do
    cond do
      pair?(tree) ->
        cons(
          tree_map(f, car(tree)),
          tree_map(f, cdr(tree))
        )
      true -> f.(tree)
    end
  end

  def print(list) do
    for_each(list, fn (n) ->
      IO.write("#{n} ")
    end)
    IO.puts("")
    list
  end

  def append(nil, list2), do: list2
  def append(list, list2) do
    cons(
      car(list),
      append(
        cdr(list),
        list2
      )
    )
  end

  def subsets(nil), do: MyList.list([nil])
  def subsets(list) do
    rest = subsets(cdr(list))
    append(rest,
           map(
             fn (x) ->
               cons(car(list), x)
             end,
             rest
           )
    )
  end

end

list1 = MyList.list([1,2, 3])
list = MyList.list([3, 4])
list2 = MyList.list([6, 7])

MyList.append(list, list2) |> MyList.print
MyList.subsets(list1) |> MyList.print

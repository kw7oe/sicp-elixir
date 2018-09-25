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

defmodule MyTree do
  import Con

  def pair(tree) do
    cond do
      !is_function(tree) -> false
      cdr(tree) == nil -> false
      true -> true
    end
  end

  def count_leaves(tree) do
    cond do
      tree == nil -> 0
      !pair(tree) -> 1
      true ->
        count_leaves(car(tree)) +
          count_leaves(cdr(tree))
    end
  end
end

list = MyList.list([1,2])
list2 = MyList.list([3,4])

x = fn (list, list2) -> Con.cons(list, list2) end
tree = x.(list, list2)

MyList.len(tree) |> IO.inspect
MyTree.count_leaves(tree) |> IO.inspect

tree2 = x.(tree, tree)
MyList.len(tree2) |> IO.inspect
MyTree.count_leaves(tree2) |> IO.inspect


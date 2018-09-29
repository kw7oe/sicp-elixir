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

  # Approach 3
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

  # Iterative
  # -> Result in reverse order
  # def map(f, list), do: map(f, list, nil)
  # def map(_, nil, new_list), do: new_list
  # def map(f, list, new_list) do
  #   map(f,
  #       cdr(list),
  #       cons(
  #         f.(car(list)),
  #         new_list)
  #   )
  # end

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
    for_each(list, fn (n) -> IO.write("#{n} ") end)
    IO.puts("")
    list
  end

  def scale_tree(nil, _factor), do: nil
  def scale_tree(tree, factor) do
    cond do
      !pair?(tree) -> tree * factor
      true ->
        cons(scale_tree(car(tree), factor),
                            scale_tree(cdr(tree), factor))
    end
  end

  def scale_tree2(tree, factor) do
    map(
      fn (sub_tree) ->
        cond do
          pair?(sub_tree) ->
            scale_tree2(sub_tree, factor)
          true -> sub_tree * factor
        end
      end,
      tree
    )
  end

  def square_tree(nil), do: nil
  def square_tree(tree) do
    cond do
      pair?(tree) ->
        cons(
          square_tree(car(tree)),
          square_tree(cdr(tree))
        )
      true -> tree * tree
    end
  end

  def square_tree2(tree) do
    map(
      fn (sub_tree) ->
        cond do
          pair?(sub_tree) ->
            square_tree2(sub_tree)
          true -> sub_tree * sub_tree
        end
      end,
      tree
    )
  end

  def square_tree3(tree) do
    tree_map(
      fn (x) -> x * x end,
      tree
    )
  end

end

list = MyList.list([3, 4])
list1 = MyList.list([2, list, 5])
list2 = MyList.list([6, 7])
list3 = MyList.list([1, list1, list2])

list3 |> MyList.print

list3 |> MyList.scale_tree(10) |> MyList.print
list3 |> MyList.scale_tree2(10) |> MyList.print

list3 |> MyList.square_tree |> MyList.print
list3 |> MyList.square_tree2 |> MyList.print
list3 |> MyList.square_tree3 |> MyList.print

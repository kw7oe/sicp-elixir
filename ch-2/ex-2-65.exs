defmodule Con do
  def cons(x, y) do
    fn (f) -> f.(x,y) end
  end

  def car(c) do
    c.(fn (x, _) -> x end)
  end

  def cdr(c) do
    c.(fn (_, y) -> y end)
  end

  def cadr(c), do: car(cdr(c))
  def caddr(c), do: car(cdr(cdr(c)))
end

defmodule MySet do
  import Con

  def set([h | []]), do: cons(h, nil)
  def set([h | t]), do: cons(h, set(t))

  def pair?(list) when is_function(list), do: true
  def pair?(_), do: false

  def append(nil, list2), do: list2
  def append(list, list2) do
    cons(
      car(list),
      append(cdr(list), list2)
    )
  end

  def entry(tree), do: car(tree)
  def left_branch(tree), do: cadr(tree)
  def right_branch(tree), do: caddr(tree)
  def make_tree(entry, left, right) do
    cond do
      is_nil(left) || is_nil(right) ->
        set([entry, left, right])
      true ->
        set([entry, make_tree(left, nil, nil), make_tree(right, nil, nil)])
    end
  end

  def puts(list) do
    puts(list, 0)
    IO.puts ""
    list
  end

  def puts(list, counter) do
    if counter == 0 && pair?(list) do
      IO.write("(")
    end
    cond do
      is_nil(list) ->
        IO.write(")")
      !pair?(list) -> IO.write("#{list}")
      true ->
        if counter != 0 do
          IO.write(" ")
        end
        car_counter = if pair?(car(list)) do
          0
        else
          counter + 1
        end

        puts(car(list), car_counter)
        puts(cdr(list), counter + 2)
    end
    list
  end

  def element_of_set?(x, set) do
    cond do
      set == nil -> false
      x == entry(set) -> true
      x < entry(set) -> element_of_set?(x, left_branch(set))
      true -> element_of_set?(x, right_branch(set))
    end
  end

  def adjoin_set(x, set) do
    cond do
      set == nil -> make_tree(x, nil, nil)
      x == entry(set) -> set
      x < entry(set) ->
        make_tree(
          entry(set),
          adjoin_set(x, left_branch(set)),
          right_branch(set)
        )
      true ->
        make_tree(
          entry(set),
          left_branch(set),
          adjoin_set(x, right_branch(set))
        )
    end
  end

  def tree_to_list(tree) do
    if is_nil(tree) do
      nil
    else
      append(
        tree_to_list(left_branch(tree)),
        cons(entry(tree), tree_to_list(right_branch(tree)))
      )
    end
  end

  def len(nil), do: 0
  def len(elements) do
    1 + len(cdr(elements))
  end

  def list_to_tree(elements) do
    car(partial_tree(elements, len(elements)))
  end

  def partial_tree(elts, n) do
    if n == 0 do
      cons(nil, elts)
    else
      left_size = div(n - 1, 2)
      left_result = partial_tree(elts, left_size)
      left_tree = car(left_result)
      non_left_elts = cdr(left_result)

      right_size = n - (left_size + 1)
      this_entry = car(non_left_elts)

      right_result = partial_tree(cdr(non_left_elts), right_size)
      right_tree = car(right_result)
      remaining_elts = cdr(right_result)

      cons(
        make_tree(this_entry, left_tree, right_tree),
        remaining_elts
      )
    end
  end

  def intersection_set_list(set1, set2) do
    cond do
      set1 == nil || set2 == nil -> nil
      true ->
        x1 = car(set1)
        x2 = car(set2)

        cond do
          x1 == x2 -> cons(x1, intersection_set_list(cdr(set1), set2))
          x1 < x2 -> intersection_set_list(cdr(set1), set2)
          x2 < x1 -> intersection_set_list(set1, cdr(set2))
        end

    end
  end

  def union_set_list(set1, set2) do
    cond do
      set1 == nil -> set2
      set2 == nil -> set1
      true ->
        x1 = car(set1)
        x2 = car(set2)

        cond do
          x1 == x2 -> union_set_list(cdr(set1), set2)
          x1 < x2 -> cons(x1, union_set_list(cdr(set1), set2))
          x2 < x1 -> cons(x2, union_set_list(set1, cdr(set2)))
        end
    end
  end

  def union_set(tree1, tree2) do
    list_to_tree(union_set_list(
      tree_to_list(tree1),
      tree_to_list(tree2)
    ))
  end

  def intersection_set(tree1, tree2) do
    list_to_tree(intersection_set_list(
      tree_to_list(tree1),
      tree_to_list(tree2)
    ))
  end
end

tree1 = MySet.make_tree(1,4,6) |> MySet.puts
tree2 = MySet.make_tree(2,3,4) |> MySet.puts
MySet.tree_to_list(tree1) |> MySet.puts |> MySet.list_to_tree |> MySet.puts
MySet.intersection_set(tree1, tree2) |> MySet.puts
MySet.union_set(tree1, tree2) |> MySet.puts




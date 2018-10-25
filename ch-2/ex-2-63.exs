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

  def tree_to_list1(tree) do
    if is_nil(tree) do
      nil
    else
      append(
        tree_to_list1(left_branch(tree)),
        cons(entry(tree), tree_to_list1(right_branch(tree)))
      )
    end
  end

  def tree_to_list2(tree) do
    copy_to_list = fn (copy_to_list, tree, result_list) ->
      if is_nil(tree) do
        result_list
      else
        copy_to_list.(
          copy_to_list,
          left_branch(tree),
          cons(
            entry(tree),
            copy_to_list.(
              copy_to_list,
              right_branch(tree),
              result_list
            )
          )
        )
      end
    end
    copy_to_list.(copy_to_list, tree, nil)
  end

end

set1 = MySet.make_tree(1,2,3) |> MySet.puts
set2 = MySet.make_tree(2,3,4) |> MySet.puts
MySet.element_of_set?(1, set1) |> MySet.puts
set3 = MySet.adjoin_set(5, set2) |> MySet.puts
MySet.tree_to_list1(set1) |> MySet.puts
MySet.tree_to_list2(set1) |> MySet.puts

MySet.tree_to_list1(set3) |> MySet.puts
MySet.tree_to_list2(set3) |> MySet.puts

# Question
# 1. Do the produce the same result?
#    > Yes
#    What list does it produce for Figure 2.16?
#    > 1 3 5 7 9 11
# 2. Do the two procedures have the same order of growth in the number
#    of steps required to convert a balanced tree with n elements to a
#    list? If not, which one grow more slowly?
#    > I don't know...

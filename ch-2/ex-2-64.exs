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
      left_tree = car(left_result) |> MySet.puts
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

end

list = MySet.set([1,3,5,7,9,11]) |> MySet.puts
MySet.len(list) |> IO.inspect
MySet.list_to_tree(list) |> MySet.puts
# Example
# -> car(partial_tree([1,3,5,7], 4))
#
# partial_tree([1,3,5,7], 4)
# -> left_size = (4 - 1) / 2
#              = 1
#    left_result = partial_tree([1,3,5,7], 1) # Line 174
#                = cons(make_tree(1, nil, nil), [3,5,7]
#    left_tree = make_tree(1, nil, nil)
#    non_left_elts = [3,5,7]
#
#    right_size = 4 - (1 + 1)
#               = 2
#    this_entry = car([3,5,7]) = 3
#
#    right_result = partial_tree([5,7], 2) # Line 194
#                 = cons(make_tree(5, nil, make_tree(7, nil, nil), [])
#    right_tree = make_tree(5, nil, make_tree(7, nil, nil))
#    remaining = []
#    cons(
#      make_tree(3, left_tree, right_tree),
#      []
#    )
#
# =>       3
#         / \
#        1   5
#           / \
#          nil 7
#             / \
#           nil nil
#
# partial_tree([1,3,5,7], 1)
# -> left_size = (1 - 1) / 2
#              = 0
#    left_result = partial_tree([1,3,5,7], 0)
#                = cons(nil, [1,3,5,7])
#    left_tree = car(left_result)
#              = nil
#    non_left_elts = [1,3,5,7]
#
#    right_size = 1 - (0 + 1)
#               = 0
#
#    this_entry = car(non_left_elts) = 1
#    right_result = partial_tree([3,5,7], 0)
#                 = cons(nil, [3,5,7]
#    right_tree = nil
#    remaining = [3,5,7]
#    cons(make_tree(1, nil, nil), remaining)
#
#
# partial_tree([5,7], 2)
# -> left_size = (2 - 1) / 2
#              = 0
#    left_result = partial_tree([5,7], 0)
#                = cons(nil, [5,7])
#    left_tree = nil
#    non_left_elts = [5,7]
#
#    right_size = 2 - (0 + 1)
#                = 1
#    this_entry = car([5,7]) = 5
#    right_result = partial_tree([7], 1) # Line 214
#                 = cons(make_tree(7, nil, nil), [])
#
#    right_tree = make_tree(7, nil, nil)
#    remaining = []
#
#    cons(make_tree(5, nil, make_tree(7, nil, nil), [])
#
#
# partial_tree([7], 1)
# -> left_size = (1 - 1) / 2
#              = 0
#    left_result = partial_tree([7], 0)
#                = cons(nil, [7])
#    left_tree = nil
#
#    non_left_elts = [7]
#
#    right_size = 1 - (0 + 1)
#               = 0
#    this_entry = 7
#
#    right_result = partial_tree([], 0)
#               = cons(nil, [])
#    right_tree = nil
#
#    cons(make_tree(7, nil, nil), [])
#
# 1. Write a short paragraph explaining as clearly as you can how partial_tree works. Draw the tree produced by list->tree for the list (1 3 5 7 9 11)
#
#  partial_tree breaks the list into three parts and recurcively break
#  those parts into tree. It then create a new tree with the entry,
#  left tree and right tree.
#
#       5
#     /   \
#    1     9
#     \    / \
#      3  7  11
#
# 2. What is the order of growth in number of steps required by list->tree to
# convert a list of n elements?
#
# To be honesnt, I don't know.

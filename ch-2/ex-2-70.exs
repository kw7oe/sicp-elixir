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
  def cadddr(c), do: car(cdr(cdr(cdr(c))))

  def cddr(c), do: cdr(cdr(c))
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

  # def adjoin_set(x, set) do
  #   cond do
  #     set == nil -> make_tree(x, nil, nil)
  #     x == entry(set) -> set
  #     x < entry(set) ->
  #       make_tree(
  #         entry(set),
  #         adjoin_set(x, left_branch(set)),
  #         right_branch(set)
  #       )
  #     true ->
  #       make_tree(
  #         entry(set),
  #         left_branch(set),
  #         adjoin_set(x, right_branch(set))
  #       )
  #   end
  # end

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

  # Huffman trees
  def make_leaf(symbol, weight) do
    set([:leaf, symbol, weight])
  end

  def leaf?(object) do
    :leaf == car(object)
  end

  def symbol_leaf(x), do: cadr(x)
  def weight_leaf(x), do: caddr(x)

  def make_code_tree(left, right) do
    set([left, right, append(symbols(left), symbols(right)),
         weight(left) + weight(right)])
  end

  def left_branch(tree), do: car(tree)
  def right_branch(tree), do: cadr(tree)

  def symbols(tree) do
    if leaf?(tree) do
      set([symbol_leaf(tree)])
    else
      caddr(tree)
    end
  end

  def weight(tree) do
    if leaf?(tree) do
      weight_leaf(tree)
    else
      cadddr(tree)
    end
  end

  def decode(bits, tree) do
    decode_1 = fn (decode_1, bits, current_branch) ->
      if is_nil(bits) do
        nil
      else
        next_branch = choose_branch(car(bits), current_branch)
        if leaf?(next_branch) do
          cons(
            symbol_leaf(next_branch),
            decode_1.(decode_1, cdr(bits), tree)
          )
        else
          decode_1.(decode_1, cdr(bits), next_branch)
        end
      end
    end
    decode_1.(decode_1, bits, tree)
  end

  def encode(message, tree) do
    if is_nil(message) do
      nil
    else
      append(
        encode_symbol(car(message), tree),
        encode(cdr(message), tree)
      )
    end
  end

  def memq(nil, _item), do: false
  def memq(set, item) do
    cond do
      item == car(set) -> true
      true -> memq(cdr(set), item)
    end
  end

  def encode_symbol(value, tree) do
    right = right_branch(tree)
    left = left_branch(tree)

    cond do
      !memq(symbols(tree), value) ->
        raise "Error: BAD SYMBOL"
      leaf?(tree) -> nil
      memq(symbols(left), value) ->
        cons(0, encode_symbol(value, left))
      memq(symbols(right), value) ->
        cons(1, encode_symbol(value, right))
    end
  end

  def choose_branch(bit, branch) do
    cond do
      bit == 0 -> left_branch(branch)
      bit == 1 -> right_branch(branch)
      true -> raise "Bad bit: CHOOSE_BRANCH"
    end
  end

  def adjoin_set(x, set) do
    cond do
      is_nil(set) -> set([x])
      weight(x) < weight(car(set)) -> cons(x, set)
      true ->
        cons(
          car(set),
          adjoin_set(x, cdr(set))
        )
    end
  end

  def make_leaf_set(pairs) do
    if is_nil(pairs) do
      nil
    else
      pair = car(pairs)
      adjoin_set(
        make_leaf(car(pair), cadr(pair)),
        make_leaf_set(cdr(pairs))
      )
    end
  end

  def generate_huffman_tree(pairs) do
    successive_merge(make_leaf_set(pairs))
  end

#   def successive_merge(leaf_set) do
#     merge = fn (f, set, acc) ->
#       cond do
#         is_nil(set) -> acc
#         true ->
#           f.(f, cdr(set), MySet.make_code_tree(car(set), acc))
#       end
#     end

#     merge.(merge, cdr(leaf_set), car(leaf_set))
#   end

  def successive_merge(set) do
    cond do
      is_nil(set) -> nil
      is_nil(cdr(set)) -> car(set)
      true -> successive_merge(
        adjoin_set(
          make_code_tree(car(set), cadr(set)),
          cddr(set)
        )
      )
    end
  end
end

set1 = MySet.set([:A, 2])
set2 = MySet.set([:BOOM, 1])
set3 = MySet.set([:GET, 2])
set4 = MySet.set([:JOB, 2])
set5 = MySet.set([:NA, 16])
set6 = MySet.set([:SHA, 3])
set7 = MySet.set([:YIP, 9])
set8 = MySet.set([:WAH, 1])
pairs = MySet.set([set1,set2,set3,set4,set5,set6,set7,set8])
message = MySet.set([
  :GET, :A, :JOB, :SHA, :NA, :NA, :NA, :NA, :NA, :NA, :NA, :NA,
  :GET, :A, :JOB, :SHA, :NA, :NA, :NA, :NA, :NA, :NA, :NA, :NA,
  :WAH, :YIP, :YIP, :YIP, :YIP, :YIP, :YIP, :YIP, :YIP, :YIP,
  :SHA, :BOOM
])

pairs = MySet.generate_huffman_tree(pairs) |> MySet.puts
bit = MySet.encode(message, pairs) |> MySet.puts
MySet.len(bit) |> IO.puts

#
# How many bits are required for the encoding?
#
# 27 x 2 + 13 + 10 + 9 = 86 bits


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

end

set1 = MySet.make_tree(1,2,3) |> MySet.puts
set2 = MySet.make_tree(2,3,4) |> MySet.puts
MySet.element_of_set?(1, set1) |> MySet.puts
MySet.adjoin_set(5, set2) |> MySet.puts

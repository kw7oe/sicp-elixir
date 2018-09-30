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


  def pair?(tree) when is_function(tree), do: true
  def pair?(_), do: false

  def odd?(number), do: rem(number, 2) != 0
  def even?(number), do: rem(number, 2) == 0

  def print(tree) when is_function(tree)  do
    print(car(tree))
    print(cdr(tree))
  end
  def print(tree), do: IO.write("#{tree} ")

  def print_list(tree) do
    IO.write("( ")
    print(tree)
    IO.write(")")
    IO.puts("")
  end

  def append(nil, list2), do: list2
  def append(list, list2) do
    cons(
      car(list),
      append(
        cdr(list),
        list2)
    )
  end

  def map(nil, _f), do: nil
  def map(list, f) do
    cons(
      f.(car(list)),
      map(cdr(list), f)
    )
  end

  def filter(nil, _p), do: nil
  def filter(seq, predicate) do
    head = car(seq)
    cond do
      predicate.(head) ->
        cons(head, filter(cdr(seq), predicate))
      true ->
        filter(cdr(seq), predicate)
    end
  end

  def accumulation(nil, _f, initial), do: initial
  def accumulation(seq, f, initial) do
    # Another apporach
    # accumulation(
    #   cdr(seq),
    #   f,
    #   f.(car(seq), initial)
    # )
    f.(
      car(seq),
      accumulation(cdr(seq), f, initial)
    )
  end

  def enumerate_interval(low, high) do
    if (low > high) do
      nil
    else
      cons(low, enumerate_interval(low + 1, high))
    end
  end

  def enumerate_tree(nil), do: nil
  def enumerate_tree(tree) do
    # cond do
    #   pair?(tree) ->
    #     cons(
    #       enumerate_tree(car(tree)),
    #       enumerate_tree(cdr(tree))
    #     )
    #   true -> tree
    # end
    cond do
      pair?(tree) ->
        append(
          enumerate_tree(car(tree)),
          enumerate_tree(cdr(tree))
        )
      true -> list([tree])
    end

  end

  def sum_odd_square(tree) do
    cond do
      is_nil(tree) -> 0
      pair?(tree) ->
        sum_odd_square(car(tree)) +
          sum_odd_square(cdr(tree))
      odd?(tree) -> tree * tree
      even?(tree) -> 0
    end
  end

  def sum_odd_square2(tree) do
    square = fn (x) -> x * x end
    tree
    |> filter(&MyList.odd?/1)
    |> enumerate_tree
    |> map(square)
    |> accumulation(&Kernel.+/2, 0)
  end

end


list = MyList.list([1,2,3,4,5,6])
list1= MyList.list([3, 4])
list2= MyList.list([2, list1])
list3= MyList.list([1, list2, 5])
square = fn (x) -> x * x end

list |> MyList.filter(&MyList.odd?/1) |> MyList.print_list
list |> MyList.sum_odd_square |> MyList.print_list
list |> MyList.map(square) |> MyList.print_list
list |> MyList.accumulation(&Kernel.+/2, 0) |> MyList.print_list
list |> MyList.accumulation(&Kernel.*/2, 1) |> MyList.print_list
MyList.enumerate_interval(2, 7) |> MyList.print_list
list3 |> MyList.enumerate_tree |> MyList.print_list
list |> MyList.sum_odd_square2 |> MyList.print_list



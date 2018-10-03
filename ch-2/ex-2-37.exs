defmodule Con do
  def cons(x, y) do
    fn (f) ->
      f.(x, y)
    end
  end

  def car(c) do
    c.(fn (x, _y) -> x end)
  end

  def cdr(c) do
    c.(fn (_x, y) -> y end)
  end
end

defmodule MyList do
  import Con

  def list([h | []]), do: cons(h, nil)
  def list([h | t]), do: cons(h, list(t))

  def each(nil, _f), do: nil
  def each(list, f) do
    f.(car(list))
    each(cdr(list), f)
  end

  def accumulate(nil, _f, initial), do: initial
  def accumulate(list, f, initial) do
    f.(
      car(list),
      accumulate(cdr(list), f, initial)
    )
  end

  def pair?(list) when is_function(list), do: true
  def pair?(_), do: false

  def print(list) do
    cond do
      is_nil(list) -> :ok
      pair?(list) ->
        print(car(list))
        print(cdr(list))
      true ->
        IO.write("#{list} ")
    end
    list
  end

  def map(list, f) do
    list
    |> accumulate(fn (x, y) -> cons(f.(x), y) end, nil)
  end

  def loop(nil, _f, acc, new_lists), do: {acc, new_lists}
  def loop(lists, f, acc, new_lists) do
    head = car(lists)
    tail = cdr(lists)
    {acc, new_lists} = f.(head, acc, new_lists)

    loop(tail, f, acc, new_lists)
  end

  def extended_map(_f, nil, _initial), do: nil
  def extended_map(f, lists, initial) do
    {acc, new_list} = lists
                      |> loop(fn (l, acc, new_lists) ->
                        head = car(l)
                        tail = cdr(l)
                        cond do
                          tail == nil ->
                            {head + acc, new_lists}
                          true ->
                            {head + acc, cons(tail, new_lists)}
                        end
                      end, 0, nil)
    cons(acc, extended_map(f, new_list, 0))
  end

  def count_leaves(tree) do
    tree
    |> map(fn (x) ->
      cond do
        pair?(x) ->
          count_leaves(x)
        true -> 1
      end
    end)
    |> accumulate(
      fn (x, y) ->
        x + y
      end,
      0
    )
  end

  def dot_product(v, w) do
    lists = list([v, w])
    extended_map(&Kernel.*/2, lists, nil) |> print
    # |> accumulate(&Kernel.+/2, 0)
  end

end

# list1 = MyList.list([1,2])
# list2 = MyList.list([2,3])
list3 = MyList.list([3,4])
list4 = MyList.list([5,6])
# list5 = MyList.list([list1,list2,list3,list4])
# list6 = MyList.list([list1,list2])

MyList.dot_product(list3, list4)




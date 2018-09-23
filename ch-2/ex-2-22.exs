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

  # To create a list using cons
  # from Elixir List
  def list([h | []]), do: cons(h, nil)
  def list([h | t]), do: cons(h, list(t))
  # list([1,2,3])
  # -> cons(1, list([2,3])
  # -> cons(1, cons(2, list[3]))
  # -. cons(1, cons(2, cons(3, nil))

  def each(nil, _f), do: :ok# nothing
  def each(list, f) do
    f.(car(list))
    each(cdr(list), f)
  end

  def print_list(list) do
    each(list, fn (n) -> IO.inspect(n) end)
  end

  def map(proc, items) do
    if items == nil do
      nil
    else
      cons(
        proc.(car(items)),
        map(proc, cdr(items))
      )
    end
  end

  def square_list(items) do
    if items == nil do
      nil
    else
      head = car(items)
      cons(
        head * head,
        square_list(cdr(items))
      )
    end
  end

  def iter_square_list(items) do
    iter_square_list(items, nil)
  end
  def iter_square_list(items, new_list) do
    cond do
      items == nil -> new_list
      true ->
        head = car(items)
        iter_square_list(
          cdr(items),
          cons(
            head * head,
            new_list
          )
        )
    end
  end

  def iter_square_list2(items) do
    iter_square_list2(items, nil)
  end
  def iter_square_list2(items, new_list) do
    cond do
      items == nil -> new_list
      true ->
        head = car(items)
        iter_square_list2(
          cdr(items),
          cons(
            new_list,
            head * head
          )
        )
    end
  end
end

list = MyList.list([1,2,3,4,5])
MyList.iter_square_list(list) |> MyList.print_list
# -> iter_square(
#      cons(1, cons(2, cons(3, cons(4, cons(5, nil))))),
#      nil
#    )
# -> iter_square(
#      cons(2, cons(3, cons(4, cons(5, nil)))),
#      cons(1, nil)
#    )
# -> iter_square(
#      cons(3, cons(4, cons(5, nil))),
#      cons(4, cons(1, nil))
#    )
# -> iter_square(
#      cons(4, cons(5, nil)),
#      cons(9, cons(4, cons(1, nil)))
#    )
# -> iter_square(
#      cons(5, nil),
#      cons(16, cons(9, cons(4, cons(1, nil))))
#    )
# -> iter_square(
#      nil,
#      cons(25, cons(16, cons(9, cons(4, cons(1, nil)))))
#    )
# -> cons(25, cons(16, cons(9, cons(4, cons(1, nil)))))


MyList.iter_square_list2(list) |> MyList.print_list
# -> iter_square(
#      cons(1, cons(2, cons(3, cons(4, cons(5, nil))))),
#      nil
#    )
# -> iter_square(
#      cons(2, cons(3, cons(4, cons(5, nil)))),
#      cons(nil, 1)
#    )
# -> iter_square(
#      cons(3, cons(4, cons(5, nil))),
#      cons(cons(nil, 1), 4)
#    )
# -> iter_square(
#      cons(4, cons(5, nil))),
#      cons(cons(cons(nil, 1), 4), 9)
#    )
# -> ......
# -> cons(cons(cons(cons(cons(nil, 1), 4), 9), 16), 25)
#
# Hence it doesn't work even if we switch the arguments)

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

  # Also Known as: accumulate
  def fold_right(nil, _f, initial), do: initial
  def fold_right(list, f, initial) do
    f.(
      car(list),
      fold_right(cdr(list), f, initial)
    )
  end

  def append(nil, list2), do: list2
  def append(list, list2) do
    cons(
      car(list),
      append(cdr(list), list2)
    )
  end

  def reverse(list) do
    f = fn (element, acc) ->
      append(acc, list([element]))
    end
    list |> fold_right(f, nil)
  end

  def fold_left(list, f, initial) do
    iter = fn (iter, result, rest) ->
      if rest == nil do
        result
      else
        iter.(
          iter,
          f.(result, car(rest)),
          cdr(rest)
        )
      end
    end
    iter.(iter, initial, list)
  end

  def reverse2(list) do
    f = fn (acc, element) ->
      cons(element, acc)
    end
    list |> fold_left(f, nil)
  end


  def pair?(list) when is_function(list), do: true
  def pair?(_), do: false

  def print(list) do
    cond do
      is_nil(list) -> :ok
      pair?(list) ->
        print(car(list))
        print(cdr(list))
        IO.puts ""
      true ->
        IO.write("#{list} ")
    end
    list
  end

end

list = MyList.list([1,2,3])

list |> MyList.reverse |> MyList.print
list |> MyList.reverse2 |> MyList.print



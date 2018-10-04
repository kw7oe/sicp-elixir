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

  # Also Known as: fold_right
  def accumulate(nil, _f, initial), do: initial
  def accumulate(list, f, initial) do
    f.(
      car(list),
      accumulate(cdr(list), f, initial)
    )
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

end

list = MyList.list([1,2,3])

list |> MyList.accumulate(&Kernel.//2, 1) |> IO.inspect
list |> MyList.fold_left(&Kernel.//2, 1) |> IO.inspect
list |> MyList.accumulate(&Kernel.+/2, 0) |> IO.inspect
list |> MyList.fold_left(&Kernel.+/2, 0) |> IO.inspect

# To guarantee that fold_right and fold_left will produce
# the same values for any sequences, the operations should be
# commutative.


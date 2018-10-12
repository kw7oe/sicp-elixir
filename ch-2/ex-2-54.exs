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

  def cadr(c) do
    car(cdr(c))
  end
end

defmodule MyList do
  import Con

  def list(nil), do: cons(nil, nil)
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

  def map(list, f) do
    list
    |> accumulate(fn (e, acc) -> cons(f.(e), acc) end, nil)
  end

  def flatmap(list, f) do
    list
    |> map(f)
    |> accumulate(&MyList.append/2, nil)
  end

  def append(nil, list2), do: list2
  def append(list, list2) do
    cons(
      car(list),
      append(cdr(list), list2)
    )
  end

  def filter(list, f) do
    list
    |> accumulate(fn (e, acc) ->
      if f.(e) do
        cons(e, acc)
      else
        acc
      end
    end, nil)
  end

  def enumerate_interval(start, endd) do
    cond do
      start > endd -> nil
      true ->
        cons(
          start,
          enumerate_interval(start + 1, endd)
        )
    end
  end

  def pair?(list) when is_function(list), do: true
  def pair?(_), do: false

  def print(nil), do: :ok
  def print(list) do
    cond do
      pair?(list) ->
        print(car(list))
        print(cdr(list))
      true -> IO.write("#{list} ")
    end
  end

  def puts(list) do
    puts(list, 0)
    IO.puts ""
    list
  end

  def puts(list, counter) do
    if counter == 0 do
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

  def remove(element, list) do
    list
    |> filter(fn (x) -> x != element end)
  end

  def memq(_item, nil), do: false
  def memq(item, x) do
    cond do
      item == car(x) -> x
      true -> memq(item, cdr(x))
    end
  end

  def equal?(nil, nil), do: true
  def equal?(list1, list2) do
    if car(list1) == car(list2) do
      equal?(cdr(list1), cdr(list2))
    else
      false
    end
  end

end


list = MyList.list([:this, :is, :a, :list])
list2 = MyList.list([:this, MyList.list([:is, :a]), :list])

MyList.equal?(list, list) |> IO.inspect
MyList.equal?(list2, list2) |> IO.inspect
MyList.equal?(list, list2) |> IO.inspect

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
    each(list, fn (n) -> IO.write("#{n} ") end)
    IO.puts("")
    list
  end

  def map(list, f) do
    list
    |> accumulate(fn (x, y) -> cons(f.(x), y) end, nil)
  end

  def append(list, list2) do
    list
    |> accumulate(&Con.cons/2, list2)
  end

  def length(list) do
    list
    |> accumulate(fn (_x, y) -> y + 1 end, 0)
  end
end


list2= MyList.list([4,6])
list = MyList.list([1,2,3,4]) |> MyList.print
list |> MyList.map(fn (x) -> x * x end) |> MyList.print
list |> MyList.append(list2) |> MyList.print
list |> MyList.length |> IO.inspect


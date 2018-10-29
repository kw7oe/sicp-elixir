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

  def key(record), do: car(record)
  def lookup(given_key, set_of_records) do
    cond do
      is_nil(set_of_records) -> false
      given_key == key(car(set_of_records)) -> car(set_of_records)
      true -> lookup(given_key, cdr(set_of_records))
    end
  end
end

record1 = MySet.set([:key, "Value"])
record2 = MySet.set([:key2, "Value2"])
records = MySet.set([record1, record2])

MySet.lookup(:key, records) |> MySet.puts
MySet.lookup(:key2, records) |> MySet.puts
MySet.lookup(:non_exist_key, records) |> MySet.puts


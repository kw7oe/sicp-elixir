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
end

defmodule MySet do
  import Con

  def set([h | []]), do: cons(h, nil)
  def set([h | t]), do: cons(h, set(t))

  def pair?(list) when is_function(list), do: true
  def pair?(_), do: false

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
      x == car(set) -> true
      x < car(set) -> false
      true -> element_of_set?(x, cdr(set))
    end
  end

  def adjoin_set(x, set) do
    cond do
      set == nil -> cons(x, set)
      x == car(set) -> set
      x < car(set) -> cons(x, set)
      true -> cons(car(set), adjoin_set(x, cdr(set)))
    end
  end

  def intersection_set(set1, set2) do
    cond do
      set1 == nil || set2 == nil -> nil
      true ->
        x1 = car(set1)
        x2 = car(set2)

        cond do
          x1 == x2 -> cons(x1, intersection_set(cdr(set1), set2))
          x1 < x2 -> intersection_set(cdr(set1), set2)
          x2 < x1 -> intersection_set(set1, cdr(set2))
        end

    end
  end

end

set1 = MySet.set([1, 4, 6, 9, 10]) |> MySet.puts
set2 = MySet.set([2,3,4]) |> MySet.puts
MySet.intersection_set(set1, set2) |> MySet.puts
MySet.adjoin_set(8, set1) |> MySet.puts
MySet.adjoin_set(1, set1) |> MySet.puts

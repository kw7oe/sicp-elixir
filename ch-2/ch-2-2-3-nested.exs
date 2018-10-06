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

  def gen_seq(n) do
    enumerate_interval(1, n)
    |> map(fn (i) ->
      enumerate_interval(1, i - 1)
      |> map(fn (j) -> list([i, j]) end)
    end)
    |> accumulate(&MyList.append/2, nil)
  end

  def prime?(n) do
    square = fn (n) -> n * n end
    devide = fn (a, b) ->
      rem(a, b) == 0
    end

    next = fn (input) ->
      cond do
        input == 2 -> 3
        true -> input + 2
      end
    end

    find_devisor = fn (find_devisor, n, test_devisor) ->
      cond do
        square.(test_devisor) > n -> n
        devide.(n, test_devisor) -> test_devisor
        true ->
          find_devisor.(find_devisor, n, next.(test_devisor))
      end
    end

    smallest_divisor = fn (n) ->
      find_devisor.(find_devisor, n, 2)
    end

    n == smallest_divisor.(n)
  end

  def prime_sum?(pair) do
    prime?(car(pair) + cadr(pair))
  end

  def make_pair_sum(pair) do
    list([car(pair), cadr(pair), (car(pair) + cadr(pair))])
  end

  def prime_sum_pairs(n) do
    enumerate_interval(1, n)
    |> flatmap(fn (i) ->
      enumerate_interval(1, i - 1)
      |> map(fn (j) -> list([i,j]) end)
    end)
    |> filter(&prime_sum?/1)
    |> map(&make_pair_sum/1)
  end

  def remove(element, list) do
    list
    |> filter(fn (x) -> x != element end)
  end

  def permutation(nil), do: list([nil])
  def permutation(s) do
    s
    |> flatmap(fn (x) ->
      permutation(remove(x, s))
      |> map(fn (p) -> cons(x, p) end)
    end)
  end

end

# Demostration for MyList.puts/1
# list1 = MyList.list([1,2])
# list2 = MyList.list([list1, 3, 4]) |> MyList.puts
# list3 = MyList.list([list1, list2]) |> MyList.puts

MyList.enumerate_interval(1, 7) |> MyList.puts
MyList.gen_seq(7) |> MyList.puts
MyList.prime_sum?(MyList.list([1,2])) |> IO.inspect
MyList.prime_sum?(MyList.list([3,5])) |> IO.inspect
MyList.prime_sum_pairs(7) |> MyList.puts
MyList.permutation(MyList.list([1,2,3])) |> MyList.puts

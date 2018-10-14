defmodule Con do
  def cons(x, y) do
    fn (c) ->
      c.(x, y)
    end
  end

  def car(c) do
    c.(fn (x, _) -> x end)
  end

  def cdr(c) do
    c.(fn (_, y) -> y end)
  end

  # Second item of a list
  def cadr(c), do: car(cdr(c))

  # Third item of a list
  def caddr(c), do: car(cdr(cdr(c)))
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

defmodule Diff do
  import Con

  def variable?(x), do: is_atom(x)
  def same_variable?(v1, v2) do
    variable?(v1) && variable?(v2) && v1 == v2
  end

  def number?(exp, num) do
    is_number(exp) && num == exp
  end

  def make_sum(a1, a2) do
    cond do
      number?(a1, 0) -> a2
      number?(a2, 0) -> a1
      is_number(a1) && is_number(a2) -> a1 + a2
      true -> MyList.list([:+, a1, a2])
    end
  end

  def make_product(m1, m2) do
    cond do
      number?(m1, 0) || number?(m2, 0) -> 0
      number?(m1, 1) -> m2
      number?(m2, 1) -> m1
      is_number(m1) && is_number(m2) -> m1 * m2
      true -> MyList.list([:*, m1, m2])
    end
  end

  def sum?(x) do
    MyList.pair?(x) && car(x) == :+
  end
  def addend(s), do: cadr(s)
  def augend(s), do: caddr(s)

  def product?(x) do
    MyList.pair?(x) && car(x) == :*
  end
  def multiplier(p), do: cadr(p)
  def multiplicand(p), do: caddr(p)

  def deriv(exp, _var) when is_number(exp), do: 0
  def deriv(exp, var) do
    cond do
      is_atom(exp) -> construct_atom(exp, var)
      sum?(exp) -> construct_sum(exp, var)
      product?(exp) -> construct_product(exp, var)
      true -> raise "unknown expression type: DERIV"
    end
  end

  defp construct_product(exp, var) do
    make_sum(
      make_product(
        multiplier(exp),
        deriv(multiplicand(exp), var)
      ),
      make_product(
        deriv(multiplier(exp), var),
        multiplicand(exp)
      )
    )
  end

  defp construct_sum(exp, var) do
    make_sum(
      deriv(addend(exp), var),
      deriv(augend(exp), var)
    )
  end

  defp construct_atom(exp, var) do
    if same_variable?(exp, var) do
      1
    else
      0
    end
  end
end

Diff.deriv(MyList.list([:+, :x, 3]), :x) |> MyList.puts
Diff.deriv(MyList.list([:*, :x, :y]), :x) |> MyList.puts

exp1 = MyList.list([:*, :x, :y])
exp2 = MyList.list([:+, :x, 3])
expression = MyList.list([:*, exp1, exp2])
Diff.deriv(expression, :x) |> MyList.puts

defmodule Con do
  def cons(x, y) do
    fn (c) ->
      c.(x, y)
    end
  end

  def car(c) do c.(fn (x, _) -> x end) end
  def cdr(c) do
    c.(fn (_, y) -> y end)
  end

  # Second item of a list
  def cadr(c), do: car(cdr(c))
  # Third item of a list
  def caddr(c), do: car(cddr(c))
  def cddr(c), do: cdr(cdr(c))
  def cdddr(c), do: cdr(cddr(c))
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
      true -> MyList.list([a1, :+,  a2])
    end
  end

  def make_product(m1, m2) do
    cond do
      number?(m1, 0) || number?(m2, 0) -> 0
      number?(m1, 1) -> m2
      number?(m2, 1) -> m1
      is_number(m1) && is_number(m2) -> m1 * m2
      true -> MyList.list([m1, :*, m2])
    end
  end

  def make_exponential(base, exp) do
    cond do
      number?(exp, 0) -> 1
      number?(exp, 1) -> base
      true -> MyList.list([base, :"**", exp])
    end
  end

  def sum?(x) do
    MyList.pair?(x) && MyList.pair?(cdr(x)) && cadr(x) == :+
  end
  def addend(s), do: car(s)
  def augend(s) do
    cond do
      cdddr(s) == nil -> caddr(s)
      product?(cddr(s)) ->
        cddr(s)
        # cons(:+, cddr(s))
      true -> cddr(s) |> MyList.puts
    end
  end

  def product?(x) do
    MyList.pair?(x) && MyList.pair?(cdr(x)) && cadr(x) == :*
  end
  def multiplier(p), do: car(p)
  def multiplicand(p) do
    cond do
      cdddr(p) == nil -> caddr(p)
      true -> cddr(p)
    end
  end

  def exponent?(x) do
    MyList.pair?(x) && car(x) == :"**"
  end
  def base(x), do: cadr(x)
  def exponent(x), do: caddr(x)

  def deriv(exp, _var) when is_number(exp), do: 0
  def deriv(exp, var) do
    cond do
      is_atom(exp) -> construct_atom(exp, var)
      sum?(exp) -> construct_sum(exp, var)
      product?(exp) -> construct_product(exp, var)
      exponent?(exp) -> construct_exponent(exp, var)
      true ->
        exp |> MyList.puts
        var |> IO.inspect
        raise "unknown expression type: DERIV"
    end
  end

  defp construct_exponent(exp, var) do
    make_product(
      make_product(
        exponent(exp),
        make_exponential(base(exp), exponent(exp) - 1)
      ),
      deriv(base(exp), var)
    )
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

list4 = MyList.list([:x, :+, :y, :+, 2])
Diff.deriv(MyList.list([:x, :+, 3, :*, list4]), :x) |> MyList.puts
Diff.deriv(MyList.list([:x, :+, 3, :*, list4]), :y) |> MyList.puts
Diff.deriv(MyList.list([:x, :+, 2]), :x) |> MyList.puts

list = MyList.list([:x, :+, :y, :+, 2])
Diff.deriv(MyList.list([:x, :*, 3, :+, 5, :*, list]), :x) |> MyList.puts

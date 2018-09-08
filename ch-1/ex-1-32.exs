defmodule MyModule do

  def accumulate(combiner, null_value, term, a, next, b) do
    if a > b do
      null_value
    else
      combiner.(
        term.(a),
        accumulate(combiner, null_value, term, next.(a), next, b)
      )
    end
  end

  def accumulate2(combiner, null_value, term, a, next, b) do
     accumulate_iter(null_value, combiner, null_value, term, a, next, b)
  end

  def accumulate_iter(acc, combiner, null_value, term, a, next, b) do
    cond do
      a > b -> acc
      true -> accumulate_iter(
        combiner.(acc, term.(a)),
        combiner,
        null_value,
        term,
        next.(a),
        next,
        b
      )
    end
  end

  def sum(term, a, next, b) do
    combiner = fn (x, y) -> x + y end
    null_value = 0
    accumulate2(combiner, null_value, term, a, next, b)
  end

  def product(term, a, next, b) do
    combiner = fn (x, y) -> x * y end
    null_value = 1

    accumulate2(combiner, null_value, term, a, next, b)
  end

  def sum_integer(a, b) do
    inc = fn (n) -> n + 1 end
    identity = fn (n) -> n end

    sum(identity, a, inc, b)
  end

  def factorial(n) do
    inc = fn (n) -> n + 1 end
    identity = fn (n) -> n end

    product(identity, 1, inc, n)
  end
end

MyModule.sum_integer(1, 10) |> IO.puts
MyModule.factorial(5) |> IO.puts

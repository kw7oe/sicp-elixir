defmodule MyModule do

  def recursive_product(term, a, next, b) do
    cond do
      a > b -> 1
      true -> term.(a) * recursive_product(term, next.(a), next, b)
    end
  end

  def iterative_product(term, a, next, b) do
      product_iter(term, a, next, b, 1)
  end
  def product_iter(term, a, next, b, acc) do
    cond do
      a > b -> acc
      true -> product_iter(term, next.(a), next, b, acc * term.(a))
    end
  end

  def factorial(n) do
    identity = fn (x) -> x end
    inc = fn (x) -> x + 1 end

    recursive_product(identity, 1, inc, n)
  end

  def iter_factorial(n) do
    identity = fn (x) -> x end
    inc = fn (x) -> x + 1 end

    iterative_product(identity, 1, inc, n)
  end

  def approxiamation_to_pie(n) do
    term = fn (n) ->
      k = 2 * n + 1
      (2 * n / k) * ((2 * n + 2) / k)
    end
    next = fn (n) -> n + 1 end


    4 * iterative_product(term, 1, next, n)
  end

end

(MyModule.factorial(5) == 120) |> IO.puts
(MyModule.iter_factorial(5) == 120) |> IO.puts
MyModule.approxiamation_to_pie(100) |> IO.puts

defmodule MyModule do

  def sum(term, a, next, b) do
    sum_iter(term, a, next, b, 0)
  end

  def sum_iter(term, a, next, b, acc) do
    cond do
      a > b -> acc
      true -> sum_iter(term, next.(a), next, b, acc + term.(a))
    end
  end

  def sum_integers(a, b) do
    identity = fn (n) -> n end
    inc = fn (n) -> n + 1 end

    sum(identity, a, inc, b)
  end
end

MyModule.sum_integers(1, 10) |> IO.puts

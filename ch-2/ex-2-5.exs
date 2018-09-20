defmodule Con do
  def cons(a, b) do
    round(:math.pow(2, a) * :math.pow(3, b))
  end

  def car(c) do
    num_div(c, 2)
  end

  def cdr(c) do
    num_div(c, 3)
  end

  def num_div(c, n), do: num_div(0, c, n)
  defp num_div(a, c, n) do
    cond do
      rem(c, n) != 0 -> a
      true -> num_div(a + 1, div(c, n), n)
    end
  end
end

c = Con.cons(1, 2)
c |> Con.car() |> IO.inspect
c |> Con.cdr() |> IO.inspect

c = Con.cons(5, 6)
c |> Con.car() |> IO.inspect
c |> Con.cdr() |> IO.inspect

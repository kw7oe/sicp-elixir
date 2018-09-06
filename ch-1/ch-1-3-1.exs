defmodule MyModule do

  def cube(a), do: a * a * a

  def sum_integers(a, b) do
    if a > b do
      0
    else
      a + sum_integers(a + 1, b)
    end
  end

  def sum_cubes(a, b) do
    if a > b do
      0
    else
      cube(a) + sum_cubes(a + 1, b)
    end
  end

  def pi_sum(a, b) do
    if a > b do
      0
    else
      (1 / (a * (a + 2)) + pi_sum(a + 4, b))
    end
  end

  # Sigma Notation
  def sum(term, a, next, b) do
    if a > b do
      0
    else
      term.(a) + sum(term, next.(a), next, b)
    end
  end

  def sum_integers_2(a, b) do
    identity = fn (n) -> n end
    inc = fn (n) -> n + 1 end

    sum(identity, a, inc, b)
  end

  def sum_cubes_2(a, b) do
    inc = fn (n) -> n + 1 end

    sum(&MyModule.cube/1, a, inc, b)
  end

  def pi_sum_2(a, b) do
    pi_term = fn (n) -> 1 / (n * (n + 2)) end
    pi_next = fn (n) -> n + 4 end

    sum(pi_term, a, pi_next, b)
  end

  def integral(f, a, b, dx) do
    add_dx = fn (x) -> x + dx end
    dx * sum(f, a + dx / 2.0, add_dx, b)
  end

end

MyModule.sum_cubes(1, 10) |> IO.puts
MyModule.sum_cubes_2(1, 10) |> IO.puts

MyModule.sum_integers(1, 10) |> IO.puts
MyModule.sum_integers_2(1, 10) |> IO.puts

8 * MyModule.pi_sum(1, 1000) |> IO.puts
8 * MyModule.pi_sum_2(1, 1000) |> IO.puts

MyModule.integral(&MyModule.cube/1, 0, 1, 0.01) |> IO.puts
MyModule.integral(&MyModule.cube/1, 0, 1, 0.001) |> IO.puts

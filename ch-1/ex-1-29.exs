defmodule MyModule do

  def cube(n), do: n * n * n

  # Sigma Notation
  def sum(term, a, next, b) do
    if a > b do
      0
    else
      term.(a) + sum(term, next.(a), next, b)
    end
  end

  # Using Simpson's Rule
  def integral(f, a, b, n) do
    h = (b - a) / n
    inc = fn (n) -> n + 1 end
    yk = fn (k) -> f.(a + k * h) end
    simpson_term = fn (k) ->
      prefix = cond do
        k == 0 || k == n -> 1
        rem(k, 2) == 0 -> 2
        true -> 4
      end

      prefix * yk.(k)
    end

    h / 3 * sum(simpson_term, 0, inc, n)
  end
end

MyModule.integral(&MyModule.cube/1, 0, 1, 100)  |> IO.puts
MyModule.integral(&MyModule.cube/1, 0, 1, 1000) |> IO.puts

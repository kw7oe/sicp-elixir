defmodule MyModule do

  # Average damp
  def average_damp(f) do
    fn (n) ->
      average(n, f.(n))
    end
  end

  def fixed_point(func, first_guess) do
    close_enough = fn (v1, v2) ->
      abs(v1 - v2) < tolerance()
    end

    tryy = fn (tryy, guess) ->
      next = func.(guess)
      if close_enough.(guess, next) do
        next
      else
        tryy.(tryy, next)
      end
    end

    tryy.(tryy, first_guess)
  end

  def sqrt(x) do
    fixed_point(
      average_damp( fn (y) -> x / y end),
      1.0)
  end

  def cube_root(x) do
    fixed_point(
      average_damp(fn (y) -> x / (y * y) end),
      1.0)
  end

  # Newton
  def deriv(g) do
    fn (x) ->
      (g.(x + dx()) - g.(x)) / dx()
    end
  end

  def newton_transform(g) do
    fn (x) ->
      x - (g.(x) / deriv(g).(x))
    end
  end

  def newton_method(g, guess) do
    fixed_point(
      newton_transform(g),
      guess)
  end

  def newton_sqrt(x) do
    newton_method(
      fn (y) ->
        :math.pow(y, 2) - x
      end,
      1.0)
  end

  # Fixed point of transform
  def fixed_point_of_transform(g, transform, guess) do
    fixed_point(
      transform.(g),
      guess
    )
  end

  def fp_sqrt(x) do
    fixed_point_of_transform(
      fn (y) -> x / y end,
      &average_damp/1,
      1.0)
  end

  def fp_sqrt_2(x) do
    fixed_point_of_transform(
      fn (y) -> (y * y) - x end,
      &newton_transform/1,
      1.0)
  end

  def cube(x), do: x * x * x

  defp tolerance, do: 0.00001
  defp dx, do: 0.0001
  defp average(x, y), do: (x + y) / 2
end

MyModule.average_damp(fn (n) -> n * n end).(10) |> IO.puts
MyModule.sqrt(2) |> IO.puts
MyModule.cube_root(2) |> IO.puts
MyModule.deriv(&MyModule.cube/1).(5) |> IO.puts
MyModule.newton_sqrt(2) |> IO.puts
MyModule.fp_sqrt(2) |> IO.puts
MyModule.fp_sqrt_2(2) |> IO.puts


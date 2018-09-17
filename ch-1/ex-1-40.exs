defmodule MyModule do
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

  def cubic(a, b, c) do
    fn (x) ->
      cube(x) + (a * square(x)) + (b * x) + c
    end
  end


  def cube(x), do: x * x * x
  def square(x), do: x * x
  defp tolerance, do: 0.00001
  defp dx, do: 0.0001
end

MyModule.newton_method(
  MyModule.cubic(1,2,3),
  1.0) |> IO.puts

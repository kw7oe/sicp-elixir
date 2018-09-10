defmodule FixedPoints do

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

  defp tolerance, do: 0.00001
end

golden_ratio = FixedPoints.fixed_point(
  fn (x) -> 1 + 1 / x end,
  1.0
)
IO.puts golden_ratio

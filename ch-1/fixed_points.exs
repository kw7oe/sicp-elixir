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

FixedPoints.fixed_point(&:math.cos/1, 1.0) |> IO.puts
sqrt = fn (x) ->
  FixedPoints.fixed_point(
    fn (y) -> (y + (x / y) ) / 2 end,
    1.0
  )
end

sqrt.(2) |> IO.puts

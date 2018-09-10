defmodule FixedPoints do

  def fixed_point(func, first_guess) do
    close_enough = fn (v1, v2) ->
      abs(v1 - v2) < tolerance()
    end

    tryy = fn (tryy, guess) ->
      next = func.(guess)
      IO.puts(next)
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

x_power_x = FixedPoints.fixed_point(
  fn (x) -> :math.log(1000) / :math.log(x)  end,
  2.0
)
IO.puts x_power_x

IO.puts "------------------------"

average_damping = FixedPoints.fixed_point(
  fn (x) ->
    (x + :math.log(1000) / :math.log(x)) / 2
  end,
  2.0
)
IO.puts average_damping

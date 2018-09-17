defmodule MyModule do

  def compose(f, g) do
    fn (x) -> f.(g.(x)) end
  end

  def repeated(func, n) do
    cond do
      n == 0 -> compose(func, func)
      true -> repeated(func, n - 1)
    end
  end

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


  def get_time(n) do
    :math.log(n) / :math.log(2)
  end

  def n_root(x, n) do
    fixed_point(
      repeated(&average_damp/1, :math.floor(get_time(n))).(
        fn (y) -> x / :math.pow(y, n - 1) end
      ),
      1.0
    )
  end

  defp tolerance, do: 0.0001
  defp average(x, y), do: (x + y) / 2
end

MyModule.n_root(256, 8) |> IO.puts

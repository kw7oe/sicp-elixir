defmodule MyModule do

  @dx 0.00001


  def compose(f, g) do
    fn (x) -> f.(g.(x)) end
  end

  def repeated(func, n) do
    cond do
      n == 0 -> compose(func, func)
      true -> repeated(func, n - 1)
    end
  end

  def smooth(func) do
    fn (x) ->
      (func.(x) + func.(x - @dx) + func.(x + @dx)) / 3
    end
  end

  def n_folded_smoothed(func, n) do
    repeated(&smooth/1, n).(func)
  end
end

MyModule.n_folded_smoothed(
  fn (x) -> x + 1 end,
  5
).(2) |> IO.puts


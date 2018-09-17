defmodule MyModule do

  def compose(f, g) do
    fn (n) ->
      f.(g.(n))
    end
  end

  def repeated(func, n) do
    cond do
      n == 0 -> compose(func, func)
      true -> repeated(func, n - 1)
    end
  end
end

square = fn (n) -> n * n end
MyModule.repeated(
  square, 2
).(5) |> IO.puts

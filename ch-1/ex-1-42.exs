defmodule MyModule do

  def compose(f, g) do
    fn (n) ->
      f.(g.(n))
    end
  end
end

MyModule.compose(
  fn (x) -> x * x end,
  fn (x) -> x + 1 end
).(6) |> IO.puts


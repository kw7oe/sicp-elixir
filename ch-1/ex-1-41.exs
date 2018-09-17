defmodule MyModule do

  def double(func) do
    fn (n) ->
      func.(func.(n))
    end
  end
end

inc = fn (n) -> n + 1 end
double = &MyModule.double/1

double.(double.(double)).(inc).(5) |> IO.puts
#


defmodule Number do

  def zero do
    fn (f) ->
      fn (x) -> x end
    end
  end

  def add_1(n) do
    fn (f) ->
      fn (x) ->
        f.(
          n.(f).(x)
        )
      end
    end
  end
end

Number.add_1(&Number.zero/0) |> IO.inspect
# add_1(zero)
# -> add_1(fn(f) ->
#      fn (x) -> x end
#    end
# -> fn (fn (f) -> fn (x) -> x end end) ->
#      fn (x) -> f.(n.(f).(x))
#    end
# -> fn (fn (f) -> fn (x) -> x end end) ->
#      fn (x) ->

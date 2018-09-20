defmodule Con do
  def cons(x, y) do
    fn (m) -> m.(x, y) end
  end

  def car(z) do
    z.(fn(x, _y) -> x end)
  end

  def cdr(z) do
    z.(fn(_x, y) -> y end)
  end
end

c = Con.cons(1, 2)
Con.car(c) |> IO.inspect
# Con.car(c)
# -> z.(fn (x, _y) -> x end)
# -> c.(fn (x, _y) -> x end)
# -> fn (m) ->
#      m.(x, y)
#    end.(fn (x, _y) -> x end)
# -> fn (x, _y) -> x end.(x, y)
# -> fn (x, y) -> x end
# -> x
Con.cdr(c) |> IO.inspect


square = fn (x) -> x * x end

IO.inspect square.(21)
#=> 441
IO.inspect square.(2 + 5)
#=> 7
IO.inspect square.(square.(3))
#=> 81


sum_of_square = fn (x, y) ->
  square.(x) + square.(y)
end
IO.inspect sum_of_square.(3, 4)
#=> 25

f = fn (a) ->
  sum_of_square.(a + 1, a * 2)
end
IO.inspect f.(5)
#=> 136

my_abs = fn (x) ->
  cond do
    x > 0 -> x
    x == 0 -> 0
    x < 0 -> -x
  end
end
IO.inspect my_abs.(-5)
#=> 5

alt_abs = fn (x) ->
  if x < 0 do: -x, else: x
end
IO.inspect alt_abs.(-5)
#=> 5



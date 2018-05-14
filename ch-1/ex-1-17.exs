mult = fn (mult, a, b) ->
  cond do
    (b == 0) -> 0
    true ->
      a + mult.(mult, a, b - 1)
  end
end

IO.inspect mult.(mult, 4, 6)
# mult.(4, 6)

# Steps:
# 4 + mult.(4, 5)
# 4 + 4 + mult.(4, 4)
# 4 + 4 + 4 + mult.(4, 3)
# 4 + 4 + 4 + 4 + mult.(4, 2)
# 4 + 4 + 4 + 4 + 4 + mult.(4, 1)
# 4 + 4 + 4 + 4 + 4 + 4 + mult.(4, 0)
# 4 + 4 + 4 + 4 + 4 + 4 + 0
# => 24

double = fn (a) -> a + a end
halve  = fn (a) -> div(a, 2) end

fast_mult = fn (fast_mult, a, b) ->
  cond do
    b == 0 -> 0
    rem(b, 2) == 0 ->
      fast_mult.(fast_mult, double.(a), halve.(b))
    true ->
      a + mult.(mult, a, b - 1)
  end
end

IO.inspect fast_mult.(fast_mult, 4, 6)
# fast_mult.(4, 6)

# Steps:
# fast_mult.(8, 3)
# 8 + fast_mult.(8, 2)
# 8 + 8 + fast_mult.(8, 1)
# 8 + 8 + 8 + fast.mult.(8, 0)
# 8 + 8 + 8 + 0
# => 24


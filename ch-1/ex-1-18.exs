double = fn (a) -> a + a end
halve  = fn (a) -> div(a, 2) end

fast_mult_iter = fn (fast_mult_iter, a, b, c) ->
  cond do
    b == 0 -> c
    rem(b, 2) == 0 ->
      fast_mult_iter.(fast_mult_iter, double.(a), halve.(b), c)
    true ->
      fast_mult_iter.(fast_mult_iter, a, b - 1, a + c)
  end
end

fast_mult = fn (a, b) ->
  fast_mult_iter.(fast_mult_iter, a, b, 0)
end

IO.inspect fast_mult.(4, 6)

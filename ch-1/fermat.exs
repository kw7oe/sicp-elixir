even = fn (n) -> rem(n, 2) == 0 end
square = fn (n) -> n * n end

expmod = fn (expmod, base, exp, m) ->
  cond do
    exp == 0 -> 1
    even.(exp) ->
      rem(
        square.(expmod.(expmod, base, div(exp, 2), m)),
        m
      )
    true ->
      rem(
        base * expmod.(expmod, base, exp - 1, m),
        m
      )
  end
end

expmod.(expmod, 2, 5, 5)

fermet_test = fn (n) ->
  random = :rand.uniform(n - 1)
  value = expmod.(expmod, random, n, n)
  value == random
end

fast_prime = fn (fast_prime, n, times) ->
  cond do
    times == 0 -> true
    fermet_test.(n) -> fast_prime.(fast_prime, n, times - 1)
    true -> false
  end
end

fast_prime.(fast_prime, 3, 3) |> IO.inspect
fast_prime.(fast_prime, 4, 3) |> IO.inspect

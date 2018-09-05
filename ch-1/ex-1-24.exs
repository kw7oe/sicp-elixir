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

# Timed Prime Test
report_prime = fn (elapsed_time) ->
  IO.puts(" *** #{elapsed_time}")
end

start_prime_test = fn (n) ->
  {time, result} = fast_prime |> :timer.tc([fast_prime, n, 100])
  if result do
    IO.write(n)
    report_prime.(time)
  end
end

timed_prime_test = fn (n) ->
  start_prime_test.(n)
end

timed_prime_test.(1009)
timed_prime_test.(1013)
timed_prime_test.(1019)
timed_prime_test.(10007)
timed_prime_test.(10009)
timed_prime_test.(10037)
timed_prime_test.(100003)
timed_prime_test.(100019)
timed_prime_test.(100043)
timed_prime_test.(1000003)
timed_prime_test.(1000033)
timed_prime_test.(1000037)

timed_prime_test.(1000000007)
timed_prime_test.(1000000009)
timed_prime_test.(1000000021)
timed_prime_test.(10000000019)
timed_prime_test.(10000000033)
timed_prime_test.(10000000061)
timed_prime_test.(100000000003)
timed_prime_test.(100000000019)
timed_prime_test.(100000000057)
timed_prime_test.(1000000000039)
timed_prime_test.(1000000000061)
timed_prime_test.(1000000000063)

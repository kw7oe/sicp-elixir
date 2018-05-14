fib = fn (fib, n) ->
  cond do
    n == 0 -> 0
    n == 1 -> 1
    true ->
      fib.(fib, n - 1) + fib.(fib, n - 2)
  end
end

fib_iter = fn (iter, a, b, n) ->
  if n == 0 do
    b
  else
    iter.(iter, a + b, a, n - 1)
  end
end
# fib(0) = 0
# fib(1) = 1
# fib(n) = fib(n - 1) + fib(n - 2)

# E.g.
# a <- a + b
# b <- a

# Hence,
# fib(1) = a
# fib(0) = b

# fib(2) = fib(1) + fib(0)
#        = a + b

# fib(3) = fib(2) + fib(1)
#        = (a + b) + a

# fib(2) = a + b
# iter.(1, 0, 2)
# iter.(1, 1, 1)
# iter.(2, 1, 0)
# => 1 (return b)

# fib(3) = fib(2) + fib(1)
# fib(3) = (a + b) + a
# iter.(1, 0, 3)
# iter.(1, 1, 2)
# iter.(2, 1, 1)
# iter.(3, 2, 0)
# => 2 (return b)

fib2 = fn (n) ->
  fib_iter.(fib_iter, 1, 0, n)
end

IO.inspect fib.(fib, 6)
IO.inspect fib2.(60)

# f(n) = n if n < 3
# f(n) = f(n - 1) + 2f(n - 1) + 3f(n - 3) if n >= 3

# Recursive Approach
f = fn (f, n) ->
  cond do
    n < 3 -> n
    true ->
      f.(f, n - 1) + 2 * f.(f, n - 2) + 3 * f.(f, n - 3)
  end
end
IO.inspect f.(f, 4)

# Iterative Approach

# f(0) = 0
# f(1) = 1
# f(2) = 2
# f(3) = f(2) + 2f(1) + 3f(0)

# Let:
# f(0) = a
# f(1) = b
# f(2) = c
# f(3) = c + 2b + 3a

# f(4) = ?
# f(4) = f(3) + 2f(2) + 3f(1)

# In this case,
# f(1) = a
# f(2) = b
# f(3) = c

# We can conclude, a, b and c is always changing.

# In f(3), a = f(0), b = f(1), c = f(2)
# In f(4), a = f(1), b = f(2), c = f(3)

# b in f(3), will become a in f(4).
# So we know that, during the next iteration:
# previous b, will become next a.
# previous c, will become next b.
# So, what will be the new c?

# In f(4), the new c is f(3), which means,
# we need to calculate f(3) and pass it
# to the next iteration.
# Hence the new c, is actually the formula,
# c + 2b + 3a.

# But then how do we know which value to return
# after the base case is met?

# g_iter.(0, 1, 2, 0)
# => 0 (which is a)

# g_iter.(0, 1, 2, 1)
# g_iter.(1, 2, 4, 0)
# => 1 (which is the a, after first iteration)

# g_iter.(0, 1, 2, 2)
# g_iter.(1, 2, 4, 1)
# g_iter.(2, 4, ?, 0)
# => 2 (which is also a)

# Hence, we know that we should return a when
# the base case is met. Since a is changing,
# in every new iteration.
#
# To handle negative number and fulfil
# f(n) = n if n < 3,

# We will need to add a condition n < 0 -> n.
g_iter = fn (g_iter, a, b ,c, n) ->
  cond do
    n == 0 -> a
    n < 0 -> n
    true ->
      g_iter.(g_iter,
              b,
              c,
              c + 2 * b + 3 * a,
              n - 1)
  end
end

# g_iter.(0, 1, 2, n)
# is due to the fact that n < 3 -> n.
# just like in fibonacci, f(0) = 0 and f(1) = 1.
# hence we can fib_iter.(1, 0, n)
g = fn (n) ->
  g_iter.(g_iter, 0, 1, 2, n)
end

IO.inspect g.(4)
IO.inspect g.(-1)

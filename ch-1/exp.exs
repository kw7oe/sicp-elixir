# b ^ n = b * b ^ (n - 1)
# b ^ 0 = 1

# Recursive Function
exp = fn (exp, b, n) ->
  if (n == 0) do
    1
  else
    # IO.puts "#{b} * exp.(#{b}, #{n - 1})"
    b * exp.(exp, b, n - 1)
  end
end

IO.inspect exp.(exp, 4, 10)


# Iterative Function
exp_iter = fn (exp_iter, b, n, a) ->
  if (n == 0) do
    a
  else
    exp_iter.(exp_iter, b, n - 1, a * b)
  end
end

exp1 = fn (b, n) ->
  exp_iter.(exp_iter, b, n, 1)
end

IO.inspect exp1.(3, 3)

# Fast Recursive Exponential
# by using successive squaring

# E.g.
# b ^ 2 = b x b
# b ^ 4 = b ^ 2 * b ^ 2
# b ^ 8 = b ^ 4 * b ^ 4
square   = fn (x) -> x * x end
fast_exp = fn (fast_exp, b, n) ->
  cond do
    n == 0 -> 1
    rem(n, 2) == 0 ->
      # IO.puts "exp.(#{b}, #{div(n, 2)})"
      square.(fast_exp.(fast_exp, b, div(n, 2)))
    true ->
      # IO.puts "#{b} * exp.(#{b}, #{n - 1})"
      b * fast_exp.(fast_exp, b, n - 1)
  end
end

IO.inspect fast_exp.(fast_exp, 4, 10)

# Fast Iterative Exponential

# Hint:
# (b ^ (n / 2)) ^ 2 = (b ^ 2) ^ (n / 2)

# What we know:
# b ^ n = b * b ^ (n - 1)

# b ^ 8 = (b ^ 4) ^ 2
#       = (b ^ 2) ^ 4

# exp_iter.(b, n, a)
# a = b ^ (n - 1)
# if n.odd? -> b * a
#           -> b * b ^ (n - 1)

# The meaning of our exp_iter in mathematical expression
# exp_iter.(b, n, a) == b ^ n
# exp_iter.(b, n/2, a) == b ^ (n / 2)

# 1. exp_iter.(b, n/2, a)^2 == (b ^ (n / 2)) ^ 2
# 2. exp_iter.(b^2, n/2, a) == (b ^ 2) ^ (n / 2)
#
# Subsitute the hint with equation 1 and 2, and we get:
# square.(exp_iter.(b, n / 2, a)) ==  exp_iter(b ^ 2, n / 2, a)
fast_exp_iter = fn (fast_exp_iter, b, n, a) ->
  cond do
    n == 0 -> a
    rem(n, 2) == 0 ->
      # IO.puts "exp.(#{square.(b)}, #{div(n, 2)}, #{a})"
      fast_exp_iter.(fast_exp_iter, square.(b), div(n, 2), a)
    true ->
      # IO.puts "exp.(#{b}, #{n - 1}, #{b * a})"
      fast_exp_iter.(fast_exp_iter, b, n - 1, b * a)
  end
end

fast_exp2 = fn (b, n) ->
  fast_exp_iter.(fast_exp_iter, b, n, 1)
end

IO.inspect fast_exp2.(4, 10)
IO.inspect fast_exp2.(2, 4)

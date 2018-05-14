cube = fn (x) -> x * x * x end
p    = fn (x) -> (3 * x ) - (4 * cube.(x)) end
sine = fn (sine, a, counter) ->
  if (!(abs(a) > 0.1)) do
    a
  else
    IO.inspect counter
    p.(sine.(sine, a / 3.0, counter + 1))
  end
end

IO.inspect :math.sin(12.15)
IO.inspect sine.(sine, 12.15, 0)

# How many times is the procedure p applied when sine.(12.15)
# is evaluated?
# 12.15 / 3 ^ n <= 0.1
# 12.15 / 0.1 <= 3 ^ n
# log10.(12.15 / 0.1) / log10.(3) <= n
# n >= 4.3....
# n >= 5

# Trace:
# sine.(12.15)
# p.( sine.(4.05) )
# p.( p.( sine.(1.35) ) )
# p.( p.( p.( sine.(0.45) ) ) )
# p.( p.( p.( p.( sine.(0.15) ) ) ) )
# p.( p.( p.( p.( p.( sine.(0.05) ) ) ) ) )

# What is the order of growth?
# O(log n)

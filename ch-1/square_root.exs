# Guess   | Quotient        | Average
# 1       | (2/1) = 2       | ((2+1)/2) = 1.5
# 1.5     | (2/1.5) = 1.333 | (1.333 + 1.5)/2 = 1.4167
# 1.4167  | ....            | ....
square = fn (x) -> x * x end
IO.inspect square.(2)
#=> 4.0

average = fn (x, y) -> (x + y) / 2 end
IO.inspect average.(10, 12)
#=> 11.0

improve = fn (guess, x) -> average.(guess, (x / guess)) end
IO.inspect improve.(1, 2)
#=> 1.5

good_enough? = fn (guess, x) -> abs(square.(guess) - x) < 0.001 end
IO.inspect good_enough?.(1.4142, 2)
#=> true

square_root_iter = fn (square_root_iter, guess, x) ->
  if good_enough?.(guess, x) do
    guess
  else
    square_root_iter.(square_root_iter, improve.(guess, x), x)
  end
end
IO.inspect square_root_iter.(square_root_iter, 1.5, 2)
#=> 1.4142...

square_root = fn (x) -> square_root_iter.(square_root_iter, 1.0, x) end
IO.puts "Square root: "
IO.inspect square_root.(3)
IO.inspect square_root.(9)
#=> 3.000....

IO.inspect square_root.(100 + 37)
#=> 11.7046...

IO.inspect square.(square_root.(1000))
#=> 1000.000...

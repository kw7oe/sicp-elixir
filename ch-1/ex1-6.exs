square = fn (x) -> x * x end
average = fn (x, y) -> (x + y) / 2 end
improve = fn (guess, x) -> average.(guess, (x / guess)) end
good_enough? = fn (guess, x) -> abs(square.(guess) - x) < 0.001 end

new_if = fn (predicate, then , else_clause) ->
  cond do
    predicate ->
      IO.puts "If"
      then
    true ->
      IO.puts "Else"
      else_clause
  end
end
IO.inspect new_if.(2 == 3, 0, 5) #=> 5
IO.inspect new_if.(2 == 2, 0, 5) #=> 0

# square_root_iter = fn (square_root_iter, guess, x) ->
#   if good_enough?.(guess, x) do
#     guess
#   else
#     square_root_iter.(square_root_iter, improve.(guess, x), x)
#   end
# end
square_root_iter = fn (square_root_iter, guess, x) ->
  new_if.(
    good_enough?.(guess, x),
    guess,
    square_root_iter.(square_root_iter, improve.(guess, x), x)
  )
end

square_root = fn (x) -> square_root_iter.(square_root_iter, 1.0, x) end
IO.inspect square_root.(2)


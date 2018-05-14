square = fn (x) -> x * x end
cube = fn (x) -> x * x * x end
average = fn (x, y, z) -> (x + y + z) / 3 end
improve = fn (guess, x) ->
  average.(
    guess, guess,
    (x / square.(guess))
  )
end
good_enough? = fn (guess, x) -> abs(cube.(guess) - x) < 0.001 end

cube_root_iter = fn (cube_root_iter, guess, x) ->
  if good_enough?.(guess, x) do
    guess
  else
    cube_root_iter.(cube_root_iter, improve.(guess, x), x)
  end
end

cube_root = fn (x) ->
  cube_root_iter.(cube_root_iter, 1.0, x)
end

IO.inspect cube_root.(27)

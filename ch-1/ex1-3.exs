square = fn (x) -> x * x end
sum_square = fn (x, y) -> square.(x) + square.(y) end

sq_sum_largest = fn (a, b, c) ->
  cond do
    a <= c && a <= b -> sum_square.(b, c)
    b <= a && b <= c -> sum_square.(a, c)
    c <= b && c <= a -> sum_square.(a, b)
    true -> nil
  end
end

13 = sq_sum_largest.(1, 2, 3)
2 = sq_sum_largest.(1, 1, 1)
8 = sq_sum_largest.(1, 2, 2)
5 = sq_sum_largest.(1, 1, 2)

IO.puts "Test passed"

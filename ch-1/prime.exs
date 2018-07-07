square = fn (n) -> n * n end

devide = fn (a, b) ->
  rem(a, b) == 0
end

find_devisor = fn (find_devisor, n, test_devisor) ->
  cond do
    square.(test_devisor) > n -> n
    devide.(n, test_devisor) -> test_devisor
    true ->
      find_devisor.(find_devisor, n, test_devisor + 1)
  end
end

smallest_divisor = fn (n) -> find_devisor.(find_devisor, n, 2) end
prime = fn (n) -> n == smallest_divisor.(n) end

# prime.(2) |> IO.inspect
# prime.(4) |> IO.inspect

# Exercise 1.21
smallest_divisor.(199) |> IO.inspect
smallest_divisor.(1999) |> IO.inspect
smallest_divisor.(19999) |> IO.inspect

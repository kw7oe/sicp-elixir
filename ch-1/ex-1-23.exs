# Find Prime
square = fn (n) -> n * n end
devide = fn (a, b) ->
  rem(a, b) == 0
end

next = fn (input) ->
  cond do
    input == 2 -> 3
    true -> input + 2
  end
end

find_devisor = fn (find_devisor, n, test_devisor) ->
  cond do
    square.(test_devisor) > n -> n
    devide.(n, test_devisor) -> test_devisor
    true ->
      find_devisor.(find_devisor, n, next.(test_devisor))
  end
end

smallest_divisor = fn (n) ->
  find_devisor.(find_devisor, n, 2)
end
prime = fn (n) ->
  n == smallest_divisor.(n)
end

# Timed Prime Test
report_prime = fn (elapsed_time) ->
  IO.puts(" *** #{elapsed_time}")
end

start_prime_test = fn (n) ->
  {time, result} = prime |> :timer.tc([n])
  if result do
    IO.write(n)
    report_prime.(time)
  end
end

timed_prime_test = fn (n) ->
  start_prime_test.(n)
end

# timed_prime_test.(5) |> IO.inspect

search = fn (search, n, acc) ->
  if (acc < 3) do
    new_acc = case timed_prime_test.(n) do
      :ok -> acc + 1
      nil -> acc
    end

    search.(search, n + 2, new_acc)
  end
end

search_for_prime = fn (n) ->
  search.(search, n + 1, 0)
end

title = fn (string) ->
  IO.puts("================")
  IO.puts(string)
  IO.puts("================")
end

# title.("Test for 1,000")
# search_for_prime.(1000)

# title.("Test for 10,000")
# search_for_prime.(10000)

# title.("Test for 100,000")
# search_for_prime.(100000)

# title.("Test for 1,000,000")
# search_for_prime.(1000000)

title.("Test for 1000000000")
search_for_prime.(1000000000)

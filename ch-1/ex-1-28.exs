even = fn (n) -> rem(n, 2) == 0 end
square = fn (n) -> n * n end

squaremod_check = fn (x, n) ->
  cond do
    x == 1 -> false
    x == (n - 1) -> false
    true -> rem(square.(x), n) == 1
  end
end

expmod = fn (func, base, exp, m) ->
  cond do
    exp == 0 -> 1
    even.(exp) ->
      x = func.(func, base, div(exp, 2), m)
      if squaremod_check.(x, m) do
        0
      else
        rem(square.(x), m)
      end
    true ->
      rem(
        base * func.(func, base, exp - 1, m),
        m
      )
  end
end

miller_rabin_test = fn (func, a, n) ->
  cond do
    a == 0 -> true
    expmod.(expmod, a, n - 1, n) == 1 -> func.(func, a - 1, n)
    true -> false
  end
end

miller_rabin = fn (n) ->
  miller_rabin_test.(miller_rabin_test, n - 1, n)
end

miller_rabin.(561) |> IO.puts
miller_rabin.(1005) |> IO.puts
miller_rabin.(7) |> IO.puts
miller_rabin.(3) |> IO.puts
miller_rabin.(2) |> IO.puts

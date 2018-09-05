even = fn (n) -> rem(n, 2) == 0 end
square = fn (n) -> n * n end

expmod = fn (expmod, base, exp, m) ->
  cond do
    exp == 0 -> 1
    even.(exp) ->
      rem(
        square.(expmod.(expmod, base, div(exp, 2), m)),
        m
      )
    true ->
      rem(
        base * expmod.(expmod, base, exp - 1, m),
        m
      )
  end
end

iter = fn (iter, a, n) ->
  cond do
    expmod.(expmod, a, n, n) == a && a < n -> iter.(iter, a + 1, n)
    a == n -> true
    true -> false
  end
end

proc = fn (n) ->
  iter.(iter, 1, n)
end

proc.(561) |> IO.puts
proc.(1105) |> IO.puts
proc.(1729) |> IO.puts
proc.(2465) |> IO.puts
proc.(2821) |> IO.puts
proc.(6601) |> IO.puts

IO.puts ""
proc.(10) |> IO.puts
proc.(155) |> IO.puts
proc.(2423) |> IO.puts

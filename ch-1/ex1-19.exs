fib_iter = fn (a, b, p, q, count, iter) ->
  cond do
    count == 0 -> b
    rem(count, 2) == 0 ->
      iter.(
        a,
        b,
        (p * p) + (q * q),
        (2 * p * q) + (q * q),
        div(count, 2),
        iter)
    true ->
      iter.(
        (b * q) + (a * q) + (a * p),
        (b * p) + (a * q),
        p,
        q,
        count - 1,
        iter)
  end
end

fib = fn (n) ->
  fib_iter.(1, 0, 0, 1, n, fib_iter)
end

fib.(4) |> IO.inspect
fib.(6) |> IO.inspect
fib.(8) |> IO.inspect

factorial = fn (fact, x) ->
  if (x == 1) do
    1
  else
    x * fact.(fact, x - 1)
  end
end

IO.inspect factorial.(factorial, 6)

fact_iter = fn (fun, n, acc, max) ->
  if (n > max), do: acc, else: fun.(fun, n + 1, n * acc, max)
end
factorial = fn (n) -> fact_iter.(fact_iter, 1, 1, n) end

IO.inspect factorial.(6)



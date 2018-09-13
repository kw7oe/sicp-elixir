defmodule MyModule do
  def cont_frac(n, d, k) do
    cont_frac_iter(0, n, d, k)
  end

  def cont_frac_iter(acc, n, d, k) do
    if k == 0 do
      acc
    else
      cont_frac_iter(
        n.(k) / (d.(k) + acc),
        n, d, k - 1)
    end
  end
end

e_euler = 2.0 + MyModule.cont_frac(
  fn (_) -> 1.0 end,
  fn (n) ->
    if rem(n - 2, 3) == 0  do
      (div(n - 2, 3) + 1) * 2
    else
      1.0
    end
  end,
  10
)
e_euler |> IO.puts

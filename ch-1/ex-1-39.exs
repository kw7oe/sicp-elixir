defmodule MyModule do
  def cont_frac(n, d, k) do
    cont_frac_iter(0, n, d, k)
  end

  def cont_frac_iter(acc, n, d, k) do
    if k == 0 do
      acc
    else
      cont_frac_iter(
        n.(k) / (d.(k) - acc),
        n, d, k - 1)
    end
  end

  def tan_cf(x, k) do
    cont_frac(
      fn (n) ->
        if (n > 1) do
          x * x
        else
          x
        end
      end,
      fn (n) -> n * 2 - 1 end,
      k)
  end
end

MyModule.tan_cf(0.2, 10) |> IO.puts
:math.tan(0.2) |> IO.puts

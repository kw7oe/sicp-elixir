defmodule MyModule do

  def cont_frac(n, d, k) do
    if k == 0 do
      0
    else
      n.(k) / (d.(k) + cont_frac(n, d, k - 1))
    end
  end

  def cont_frac2(n, d, k) do
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

MyModule.cont_frac(
  fn (_) -> 1.0 end,
  fn (_) -> 1.0 end,
  50
) |> IO.puts

MyModule.cont_frac2(
  fn (_) -> 1.0 end,
  fn (_) -> 1.0 end,
  50
) |> IO.puts

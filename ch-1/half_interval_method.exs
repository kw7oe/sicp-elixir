defmodule HalfInterval do

  def half_interval_method(func, a, b) do
    a_value = func.(a)
    b_value = func.(b)
    cond do
      negative(a_value) && positive(b_value)  -> search(func, a, b)
      negative(b_value) && positive(a_value)  -> search(func, b, a)
      true -> raise "Value are not of opposite sign"
    end
  end

  defp search(func, negative_point, positive_point) do
    midpoint = (negative_point + positive_point) / 2
     if close_enough(negative_point, positive_point) do
       midpoint
     else
       test_value = func.(midpoint)
       cond do
         positive(test_value) -> search(func, negative_point, midpoint)
         negative(test_value) -> search(func, midpoint, positive_point)
         true -> midpoint
       end
     end
  end

  defp positive(x), do: x > 0
  defp negative(x), do: x < 0
  defp close_enough(x, y), do: abs(x - y) < 0.001
end

HalfInterval.half_interval_method(&:math.sin/1, 2.0, 4.0) |> IO.puts
HalfInterval.half_interval_method(
  fn (x) -> (x * x * x) - 2 * x - 3 end,
  1,
  2
) |> IO.puts

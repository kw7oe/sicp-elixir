defmodule Con do
  def cons(x, y) do
    fn (f) -> f.(x, y) end
  end

  def car(f) do
    f.(fn (x, _y) -> x end)
  end

  def cdr(f) do
    f.(fn (_x, y) -> y end)
  end
end

defmodule Interval do
  import Con

  def make_interval(a, b) do
    cons(a, b)
  end

  def upper_bound(x) do
    cdr(x)
  end

  def lower_bound(y) do
    car(y)
  end

  def my_max(w, x, y, z) do
    result = max(w, x)
    result = max(result, y)
    result = max(result, z)
    result
  end

  def my_min(w, x, y, z) do
    result = min(w, x)
    result = min(result, y)
    result = min(result, z)
    result
  end

  def add_interval(x, y) do
    make_interval(
      lower_bound(x) + lower_bound(y),
      upper_bound(x) + upper_bound(y)
    )
  end

  def sub_interval(x, y) do
    add_interval(
      x,
      make_interval(
        -upper_bound(y),
        -lower_bound(y)
      )
    )
  end

  def mul_interval(x, y) do
    p1 = lower_bound(x) * lower_bound(y)
    p2 = lower_bound(x) * upper_bound(y)
    p3 = upper_bound(x) * lower_bound(y)
    p4 = upper_bound(x) * upper_bound(y)

    make_interval(
      my_min(p1, p2, p3, p4),
      my_max(p1, p2, p3, p4)
    )
  end

  def div_interval(x ,y) do
    mul_interval(
      x,
      make_interval(
        upper_bound(y) / 1.0,
        lower_bound(y) / 1.0
      )
    )
  end
end

Interval.my_max(1,2,3,4) |> IO.inspect
Interval.my_min(1,2,3,4) |> IO.inspect

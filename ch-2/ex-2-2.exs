defmodule Con do
  def con(n, d), do: [n, d]
  def car(x) do
    [h | _ ] = x
    h
  end
  def cdr(x) do
    List.last(x)
  end
end

defmodule Point do
  import Con
  def make_point(x, y) do
    con(x, y)
  end

  def x_point(p) do
    car(p)
  end

  def y_point(p) do
    cdr(p)
  end

  def print_point(p) do
    IO.puts("(#{x_point(p)},#{y_point(p)})")
  end
end

defmodule Segment do
  import Con
  import Point

  def make_segment(p1, p2) do
    con(p1, p2)
  end

  def start_segment(s) do
    car(s)
  end

  def end_segment(s) do
    cdr(s)
  end

  def midpoint_segment(s) do
    start = start_segment(s)
    endd  = end_segment(s)

    make_segment(
      (x_point(start) + x_point(endd)) / 2,
      (y_point(start) + y_point(endd)) / 2
    )
  end

end


segment = Segment.make_segment(
  Point.make_point(5, 1),
  Point.make_point(5, 5)
)
segment2 = Segment.make_segment(
  Point.make_point(5, 1),
  Point.make_point(1, 5)
)

Segment.midpoint_segment(segment) |> IO.inspect
Segment.midpoint_segment(segment2) |> IO.inspect


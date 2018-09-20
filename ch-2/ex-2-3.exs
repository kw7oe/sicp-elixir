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

defmodule Rectangle do
  import Con
  import Point # Representation 1
  import Segment # Representation 2

  def make_rect(c1,c2) do
    con(c1, c2)
  end

  # Representation 1
  # def width(rect) do
  #   abs(x_point(car(rect)) - x_point(cdr(rect)))
  # end

  # def len(rect) do
  #   abs(y_point(car(rect)) - y_point(cdr(rect)))
  # end

  # Representation 2
  def width(rect) do
    segment = cdr(rect)
    abs(
      y_point(start_segment(segment)) -
        y_point(end_segment(segment))
    )
  end

  def len(rect) do
    segment = car(rect)
    abs(
      x_point(start_segment(segment)) -
        x_point(end_segment(segment))
    )
  end


  def perimeter(rect) do
    2 * len(rect) + 2 * width(rect)
  end

  def area(rect) do
    len(rect) * width(rect)
  end
end

# Representation 1
# *
#
#      *

# rect1 = Rectangle.make_rect(
#   Point.make_point(0, 0),
#   Point.make_point(6, 5)
# )

# Representation 2
# -----
#     |
#     |
#     |

rect1 = Rectangle.make_rect(
  # Vertical
  Segment.make_segment(
    Point.make_point(0, 5),
    Point.make_point(6, 5)
  ),
  # Horizontal
  Segment.make_segment(
    Point.make_point(0, 0),
    Point.make_point(0, 5)
  )
)


rect1 |> Rectangle.perimeter() |> IO.puts
rect1 |> Rectangle.area() |> IO.puts


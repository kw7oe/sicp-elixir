defmodule Rational do

  def con(n, d), do: [n, d]
  def car(x) do
    [h | _ ] = x
    h
  end
  def cdr(x) do
    List.last(x)
  end
  def gcd(n, d) do
    cond do
      d == 0 -> n
      true -> gcd(d, rem(n, d))
    end
  end

  def make_rat(n, d) do
    g = gcd(n, d)
    con(div(n, g), div(d, g))
  end

  def numer(x) do
    car(x)
  end

  def denom(x) do
    cdr(x)
  end

  def add_rat(x, y) do
    make_rat(
      numer(x) * denom(y) + numer(y) * denom(x),
      denom(x) * denom(y)
    )
  end

  def sub_rat(x, y) do
    make_rat(
      numer(x) * denom(y) - numer(y) * denom(x),
      denom(x) * denom(y)
    )
  end

  def mul_rat(x, y) do
    make_rat(
      numer(x) * numer(y),
      denom(x) * denom(y)
    )
  end

  def div_rat(x, y) do
    make_rat(
      numer(x) * denom(y),
      numer(y) * denom(x)
    )
  end

  def equal_rat(x, y) do
    numer(x) * denom(y) == numer(y) * denom(x)
  end

  def print_rat(x) do
    IO.inspect("#{numer(x)}/#{denom(x)}")
  end

end

x = Rational.con(1, 2)
y = Rational.con(3, 4)
z = Rational.con(x, y)

Rational.car(Rational.car(z)) |> IO.inspect
Rational.car(Rational.cdr(z)) |> IO.inspect

x |> Rational.print_rat
y |> Rational.print_rat

one_half = Rational.make_rat(1,2)
Rational.print_rat(one_half)

one_third = Rational.make_rat(1,3)
Rational.print_rat(one_third)

Rational.print_rat(
  Rational.mul_rat(one_half, one_third)
)

Rational.print_rat(
  Rational.add_rat(one_third, one_third)
)


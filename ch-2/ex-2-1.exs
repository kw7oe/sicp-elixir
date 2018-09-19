defmodule Rational do

  def make_rat(n, d) do
    d = cond do
      n < 0 && d > 0 -> d * -1
      true -> d
    end

    n = cond do
      n < 0 -> abs(n)
      true -> n
    end

    g = gcd(n, d)
    con(div(n, g), div(d, g))
  end

  def numer(x) do
    car(x)
  end

  def denom(x) do
    cdr(x)
  end

  def print_rat(x) do
    IO.inspect("#{numer(x)}/#{denom(x)}")
  end

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
end

Rational.make_rat(-1, -2) |> Rational.print_rat
Rational.make_rat(5, -10) |> Rational.print_rat

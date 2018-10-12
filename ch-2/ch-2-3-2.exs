defmodule Con do
  def cons(x, y) do
    fn (c) ->
      c.(x, y)
    end
  end

  def car(c) do
    c.(fn (x, _) -> x end)
  end

  def cdr(c) do
    c.(fn (_, y) -> y end)
  end

  def cadr(c) do
    car(cdr(c))
  end
end

defmodule Diff do

  def derive(exp, _), do: raise "unknown expression type: DERIV #{exp}"
  def deriv(exp, var), when is_number(exp) do
    cond do
      is_atom(exp) -> construct_atom(exp, var)
      sum?(exp) -> construct_sum(exp, var)
      product?(exp) -> construct_product(exp, var)
    end
  end

  defp construct_product(exp, var) do
    make_sum(
      make_product(
        multiplier(exp),
        deriv(multiplicand(exp), var)
      ),
      make_product(
        deriv(multiplicand(exp), var),
        multiplicand(exp)
      )
    )
  end

  defp construct_sum(exp, var) do
    make_sum(
      deriv(addend(exp), var),
      derive(augend(exp), var)
    )
  end

  defp construct_atom(exp, var) do
    if same_variable?(exp, var) do
      1
    else
      0
    end
  end
end


defmodule Con do
  def cons(x, y) do
    fn (f) ->
      f.(x, y)
    end
  end

  def car(c) do
    c.(fn (x, _y) -> x end)
  end

  def cdr(c) do
    c.(fn (_x, y) -> y end)
  end
end

defmodule MyList do
  import Con

  def list([h | []]), do: cons(h, nil)
  def list([h | t]), do: cons(h, list(t))

  def each(nil, _f), do: nil
  def each(list, f) do
    f.(car(list))
    each(cdr(list), f)
  end

  def accumulate(nil, _f, initial), do: initial
  def accumulate(list, f, initial) do
    f.(
      car(list),
      accumulate(cdr(list), f, initial)
    )
  end

  def pair?(list) when is_function(list), do: true
  def pair?(_), do: false

  def print(list) do
    each(list, fn (n) -> IO.write("#{n} ") end)
    IO.puts("")
    list
  end

  def horner_eval(coefficient_sequence, x) do
    coefficient_sequence
    |> accumulate(fn (this_coeff, higher_terms) ->
      this_coeff + higher_terms * x
    end, 0)
  end

end


list2= MyList.list([1,3,0,5,0,1])
list2 |> MyList.horner_eval(2) |> IO.inspect

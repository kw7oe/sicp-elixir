defmodule MyModule do

  def iterative_improve(good_enough, improve) do
    fn (guess, iter) ->
      if good_enough.(guess) do
        guess
      else
        iter.(improve.(guess), iter)
      end
    end
  end

  def square_root(x) do
    func = iterative_improve(
      fn (guess) -> abs(guess * guess - x) < 0.001 end,
      fn (guess) -> (guess + x / guess) / 2 end
    )
    func.(1.0, func)
  end

  def fixed_point(func, guess) do
    close_enough = fn (v1, v2) ->
      abs(v1 - v2) < 0.00001
    end

    f = iterative_improve(
      fn (guess) -> close_enough.(func.(guess), guess) end,
      func
    )

    f.(guess, f)
  end
end

MyModule.square_root(2) |> IO.puts
sqrt = fn (x) ->
  MyModule.fixed_point(
    fn (y) -> (y + (x / y) ) / 2 end,
    1.0
  )
end

sqrt.(2) |> IO.puts

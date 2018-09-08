defmodule MyModule do
  def filter_accumulate(combiner, filter, null_value, term, a, next, b) do
    cond do
      a > b -> null_value
      true ->
        value = if filter.(a) do
          term.(a)
        else
          null_value
        end

        combiner.(
          value,
          filter_accumulate(
            combiner,
            filter,
            null_value,
            term,
            next.(a),
            next,
            b
          )
        )
    end
  end

  def sum_square_prime(a, b) do
    square = fn (n) -> n * n end
    inc = fn (n) -> n + 1 end

    devide = fn (a, b) ->
      rem(a, b) == 0
    end

    find_devisor = fn (find_devisor, n, test_devisor) ->
      cond do
        square.(test_devisor) > n -> n
        devide.(n, test_devisor) -> test_devisor
        true ->
          find_devisor.(find_devisor, n, test_devisor + 1)
      end
    end

    smallest_divisor = fn (n) -> find_devisor.(find_devisor, n, 2) end
    prime = fn (n) -> n == smallest_divisor.(n) && n != 1 end

    filter_accumulate(&Kernel.+/2, prime, 0, square, a, inc, b)
  end

  def product_relative_prime(n) do
    gcd = fn (gcd, a, b) ->
      cond do
        b == 0 -> a
        true -> gcd.(gcd, b, rem(a, b))
      end
    end
    filter = fn (i) ->
      gcd.(gcd, i, n) == 1
    end

    identity = fn (a) -> a end
    inc = fn (a) -> a + 1 end

    filter_accumulate(&Kernel.*/2, filter, 1, identity, 0, inc, n)
  end

end

MyModule.sum_square_prime(1,5) |> IO.puts
MyModule.product_relative_prime(10) |> IO.puts

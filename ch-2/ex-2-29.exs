defmodule Con do
  def cons(x, y) do
    fn (f) -> f.(x, y) end
  end

  def car(c) do
    c.(fn (x, _y) -> x end)
  end

  def cdr(c) do
    c.(fn(_x, y) -> y end)
  end
end

defmodule Mobile do
  import Con

  def list([h | []]), do: cons(h, nil)
  def list([h | t]), do: cons(h, list(t))

  # Approach One
  # def for_each(nil, _f), do: :ok# nothing
  # def for_each(list, f) do
  #   f.(car(list))
  #   for_each(cdr(list), f)
  # end
  # def print(list) do
  #   print_list(list)
  #   IO.puts ""
  # end
  # def print_list(list) do
  #   print = fn (n) -> IO.write("#{n} ") end

  #   for_each(list, fn (n) ->
  #     if is_function(n) do
  #       print_list(n)
  #     else
  #       print.(n)
  #     end
  #   end)
  # end

  # Approach Two
  def for_each(nil, _f), do: :ok# nothing
  def for_each(list, f)  do
    head = car(list)
    cond do
      is_function(head) ->
        for_each(head, f)
        for_each(cdr(list), f)
      true ->
        f.(head)
        for_each(cdr(list), f)
    end
  end

  def print(list) do
    for_each(list, fn (n) -> IO.write("#{n} ") end)
    IO.puts("")
  end

  def make_mobile(left, right) do
    list([left, right])
  end

  def make_branch(length, structure) do
    list([length, structure])
  end

  def left_branch(mobile) do
    car(mobile)
  end

  def right_branch(mobile) do
    cdr(mobile)
  end

  def branch_length(branch) do
    car(branch)
  end

  def branch_structure(branch) do
    cdr(branch)
  end
end

branch = Mobile.make_branch(5, 7)
branch |> Mobile.print

branch2 = Mobile.make_branch(6, branch)
branch2 |> Mobile.print

mobile = Mobile.make_mobile(branch, branch2)
mobile |> Mobile.print


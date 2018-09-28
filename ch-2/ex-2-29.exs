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
        IO.puts("")
        for_each(cdr(list), f)
      true ->
        f.(head)
        for_each(cdr(list), f)
    end
  end

  def print(list) do
    for_each(list, fn (n) -> IO.write("#{n} ") end)
    IO.puts("")
    list
  end

  def make_mobile(left, right) do
    list([left, right])
    # Version 2
    # cons(left, right)
  end

  def make_branch(length, structure) do
    list([length, structure])
    # Version 2
    # cons(length, structure)
  end

  def left_branch(mobile) do
    car(mobile)
  end

  def right_branch(mobile) do
    car(cdr(mobile))
    # Version 2
    # cdr(mobile)
  end

  def branch_length(branch) do
    car(branch)
  end

  def branch_structure(branch) do
    car(cdr(branch))
    # Version 2
    # cdr(branch)
  end

  def total_weight(mobile) when is_function(mobile) do
    right_structure = branch_structure(right_branch(mobile))
    left_structure = branch_structure(left_branch(mobile))
    total_weight(right_structure) + total_weight(left_structure)
  end
  def total_weight(mobile), do: mobile

  def branch_weight(branch) do
    len = branch_length(branch)
    structure = branch_structure(branch)
    len * total_weight(structure)
  end

  def is_balance(mobile) do
    top_right = right_branch(mobile)
    top_left = left_branch(mobile)
    branch_weight(top_left) == branch_weight(top_right)
  end
end

branch = Mobile.make_branch(5, 8) |> Mobile.print
branch2 = Mobile.make_branch(10, 4) |> Mobile.print
mobile = Mobile.make_mobile(branch, branch2) |> Mobile.print

branch3 = Mobile.make_branch(5, mobile)
mobile2 = Mobile.make_mobile(branch, branch3) |> Mobile.print

Mobile.total_weight(mobile) |> IO.inspect
Mobile.total_weight(mobile2) |> IO.inspect

Mobile.is_balance(mobile) |> IO.inspect
Mobile.is_balance(mobile2) |> IO.inspect

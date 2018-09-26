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

defmodule MyList do
  import Con

  # To create a list using cons
  # from Elixir List
  def list([h | []]), do: cons(h, nil)
  def list([h | t]), do: cons(h, list(t))
  # list([1,2,3])
  # -> cons(1, list([2,3])
  # -> cons(1, cons(2, list[3]))
  # -. cons(1, cons(2, cons(3, nil))

  def for_each(nil, _f), do: :ok# nothing
  def for_each(list, f) do
    f.(car(list))
    for_each(cdr(list), f)
  end

  def print_list(list) do
    print = fn (n) -> IO.write("#{n} ") end

    for_each(list, fn (n) ->
      if is_function(n) do
        for_each(n, print)
      else
        print.(n)
      end
    end)

    IO.puts ""
  end

  def reverse(list) do
    head = car(list)
    tail = cdr(list)
    reverse(tail, cons(head, nil))
  end

  def reverse(list, new_list) do
    head = car(list)
    tail = cdr(list)
    cond do
      tail == nil -> cons(head, new_list)
      true -> reverse(tail, cons(head, new_list))
    end
  end

  def deep_reverse(list) do
    head = car(list)
    tail = cdr(list)

    new_list = cond do
      is_function(head) -> deep_reverse(head)
      true -> cons(head, nil)
    end

    deep_reverse(tail, new_list)
  end

  def deep_reverse(list, new_list) do
    head = car(list)
    tail = cdr(list)

    cond do
      tail == nil && is_function(head) ->
        cons(deep_reverse(head), new_list)
      tail == nil -> cons(head, new_list)
      is_function(head) ->
        deep_reverse(tail, deep_reverse(head))
      true ->
        deep_reverse(tail, cons(head, new_list))
    end
  end
end

list1 = MyList.list([1,2])
list2 = MyList.list([3,4])
x = MyList.list([list1, list2])
reverse_x = MyList.reverse(x)
deep_reverse_x = MyList.deep_reverse(x)

x |> MyList.print_list
reverse_x |> MyList.print_list
deep_reverse_x |> MyList.print_list

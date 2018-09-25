list1 = [1, 3, [5, 7], 9]
list2 = [[7]]
list3 = [1, [2, [3, [4, [5, [6, 7]]]]]]

car = fn ([h | _t]) -> h end
cdr = fn ([_h | t]) -> t end

car.(cdr.(car.(cdr.(cdr.(list1))))) |> IO.inspect
car.(car.(list2)) |> IO.inspect
car.(cdr.(car.(cdr.(car.(cdr.(car.(cdr.(car.(cdr.(car.(cdr.(list3)))))))))))) |> IO.inspect



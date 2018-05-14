# Pascal Triangle
# 1:     1
# 2:    1 1
# 3:   1 2 1
# 4:  1 3 3 1
# 5: 1 4 6  4 1

# Row: 5, Column: 2 == 5r2c
# = 4
# = 1 + 3
# = 4r1c + 4r2c
# = (Row - 1)r(Column - 1)c + (Row - 1)r(Column)c

# First and last columns is always 1.
# => if (column == 1), do: 1

# Last column depends on the row number.
# Last Column == Row Number.
# => if (column == row), do: 1
pascal = fn (p, row, col) ->
  if (col == 1 || col == row) do
    1
  else
    p.(p, row - 1, col - 1) + p.(p, row - 1, col)
  end
end

IO.inspect pascal.(pascal, 1, 1)
IO.inspect pascal.(pascal, 2, 1)
IO.inspect pascal.(pascal, 2, 2)
IO.inspect pascal.(pascal, 3, 1)
IO.inspect pascal.(pascal, 3, 2)
IO.inspect pascal.(pascal, 3, 3)
IO.inspect pascal.(pascal, 4, 3)
IO.inspect pascal.(pascal, 5, 2)
IO.inspect pascal.(pascal, 5, 3)

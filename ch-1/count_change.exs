first_domination = fn (kind_of_coins) ->
  cond do
    kind_of_coins == 1 -> 1 # Value of the coin
    kind_of_coins == 2 -> 5
    kind_of_coins == 3 -> 10
    kind_of_coins == 4 -> 25
    kind_of_coins == 5 -> 50
  end
end

cc = fn (cc, amount, kind_of_coins) ->
  cond do
    amount == 0 -> 1
    amount < 0 || kind_of_coins == 0 -> 0
    true ->
      cc.(cc, amount, kind_of_coins - 1) + cc.(cc, amount - first_domination.(kind_of_coins), kind_of_coins)
  end
end

# With printing
# cc = fn (cc, amount, kind_of_coins, space) ->
#   cond do
#     amount == 0 ->
#       # IO.puts "cc.(#{amount}, #{kind_of_coins}) -> 1"
#       1
#     amount < 0 || kind_of_coins == 0 ->
#       # IO.puts "cc.(#{amount}, #{kind_of_coins}) -> 0"
#       0
#     true ->
#       # IO.puts "cc.(#{amount}, #{kind_of_coins - 1}) + cc.(#{amount - first_domination.(kind_of_coins)}, #{kind_of_coins})"
#       a = cc.(cc, amount, kind_of_coins - 1, space + 2)
#       b = cc.(cc, amount - first_domination.(kind_of_coins), kind_of_coins, space + 2)
#       IO.puts String.duplicate(" ", space) <> "#{a} + #{b}"
#       a + b
#   end
# end

# Amount in cents
count_change = fn (amount) ->
  # Two kind of coins, 25 cents and 50 cents
  # cc.(cc, amount, 5, 0) # With Printing
  cc.(cc, amount, 5)
end


# IO.inspect count_change.(100)
# {25, 25, 25, 25}
# {50, 50}
# {50, 25, 25}
#=> 3 ways

IO.inspect count_change.(11)
# cc.(11, 5)
#     cc.(11, 4) + cc.(-39, 5)
#         cc.(11, 3) + cc.(-14, 4) + 0
#             cc.(11, 2) + cc.(1, 3) + 0 + 0
#                 cc.(11, 1) + cc.(6, 2) + cc.(1, 2) + cc.(-9, 2)

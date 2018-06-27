gcd = fn (a, b, gcd) ->
  if b == 0 do
    a
  else
    gcd.(b, rem(a, b), gcd)
  end
end


gcd.(206, 40, gcd) |> IO.inspect

# ============================
# Applicative Order Evaluation
# ============================

# gcd.(206, 40)
# -> gcd( 40, rem(206, 40) )
# -> gcd( 40, 6 )
# -> gcd( 6, rem(40, 6) )
# -> gcd( 6, 4 )
# -> gcd( 4, rem(6, 4) )
# -> gcd( 4, 2 )
# -> gcd( 2, rem(4, 2) )
# -> gcd( 2, 0 )
# -> 2
#
# Count of rem = 4


# =======================
# Normal Order Evaluation
# =======================

# gcd.(a, b)
# gcd.(206, 40)
#   if 40 == 0
#   else
#
#     gcd.(40, rem(206, 40))
#       -> if rem(206, 40) == 0
#       -> if 6 == 0
#          else
#
#            gcd.(
#              rem(206,40),
#              rem(40, rem(206,40))
#            )
#              -> if rem(40, rem(206,40)) == 0
#              -> if rem(40, 6) == 0
#              -> if 4 == 0
#                 else
#
#                   gcd.(
#                     rem(40, rem(206,40)),
#                     rem(
#                       rem(206,40),
#                       rem(40, rem(206,40))
#                     )
#                   )
#                     -> if rem(
#                             rem(206,40),
#                             rem(40, rem(206,40))
#                           ) == 0
#                     -> if rem(6, rem(40,rem(206,40)) == 0
#                     -> if rem(6, rem(40, 6)) == 0
#                     -> if rem(6, 4) == 0
#                     -> if 2 == 0
#                        else
#
#                          gcd.(
#                            rem(rem(206,40),rem(40,rem(206,40))),
#                            rem(
#                              rem(40,rem(206,40)),
#                              rem(rem(206,40),rem(40,rem(206,40)))
#                          )
#                            -> if rem(
#                              rem(40,rem(206,40)),
#                              rem(
#                                rem(206,40),rem(40,rem(206,40)))
#                              )
#                            -> if rem(
#                              rem(40,6),
#                              rem(
#                                rem(206,40),rem(40,rem(206,40)))
#                              )
#                            -> if rem(
#                              rem(40,6),
#                              rem(6,rem(40,rem(206,40)))
#                              )
#                            -> if rem(
#                              rem(40,6),
#                              rem(6,rem(40,6))
#                              )
#                            -> if rem(4,
#                              rem(6,rem(40,6))
#                              )
#                            -> if rem(4, rem(6,4))
#                            -> if rem(4, 2) == 0
#                            -> if 0 == 0
#                                 -> rem(rem(206,40), rem(40, rem(206,40))
#                                 -> rem(6, rem(40, rem(206,40))
#                                 -> rem(6, rem(40, 6))
#                                 -> rem(6, 4)
#                                 -> 2

# =========
# Summarize
# =========

# Executed `rem` statement
# if rem(206, 40) == 0 (1)
# if rem(40, rem(206,40)) == 0 (2)
# if rem(rem(206,40),rem(40, rem(206,40))) == 0 (4)
# if rem(rem(40,rem(206,40)),rem(rem(206,40),rem(40,rem(206,40)))) == 0 (7)
# rem(rem(206,40), rem(40, rem(206,40)) (4)
#
# => 1 + 2 + 4 + 7 + 4
# => 18

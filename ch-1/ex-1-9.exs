inc = fn (a) -> a + 1 end
dec = fn (a) -> a - 1 end

plus = fn (plus, a, b) ->
  if a == 0 do
    b
  else
    inc.(
      plus.(plus, dec.(a), b)
    )
  end
end

plus1 = fn (plus, a, b) ->
  if a == 0 do
    b
  else
    plus.(plus, dec.(a), inc.(b))
  end
end

IO.inspect plus.(plus, 4, 5)
# plus.( 4, 5 )
# inc.( plus.( dec.(4), 5 ) )
# inc.( plus.( 3, 5 ) )
# inc.( inc.( plus.( dec.(3), 5 ) ) )
# inc.( inc.( plus.( 2, 5 ) ) )
# inc.( inc.( inc.( plus.( dec.(2) , 5 ) ) ) )
# inc.( inc.( inc.( plus.( 1, 5 ) ) ) )
# inc.( inc.( inc.( inc.( plus.( dec.(1), 5 ) ) ) ) )
# inc.( inc.( inc.( inc.( plus.( 0, 5 ) ) ) ) )
# inc.( inc.( inc.( inc.( 5 ) ) ) )
# inc.( inc.( inc.( 6 ) ) )
# inc.( inc.( 7 ) )
# inc.( 8 )
# 9
#
# Hence, it is recursive.
IO.inspect plus1.(plus1, 4, 5)
# plus.( 4, 5 )
# plus.( dec.(4), inc.(5) )
# plus.( 3, 6 )
# plus.( dec.(3), inc.(6) )
# plus.( 2, 7 )
# plus.( dec.(2), inc.(7) )
# plus.( 1, 8 )
# plus.( dec.(1), inc.(8) )
# plus.( 0, 9 )
# 9
#
# Hence, it is iterative.


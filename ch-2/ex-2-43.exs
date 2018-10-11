# The reason the program run slowly, is due
# to the recursive function call of queen_cols
# in every new row.
#
# With the change of the order of nested mappings in
# flatmap, the time take will be (board_size ^ board_size)T.

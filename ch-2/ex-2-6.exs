# Church Numerals.
# I am stuck here.
defmodule Number do

  def zero do
    fn (f) ->
      fn (x) -> x end
    end
  end

  def add_1(n) do
    fn (f) ->
      fn (x) ->
        f.(
          n.(f).(x)
        )
      end
    end
  end
end


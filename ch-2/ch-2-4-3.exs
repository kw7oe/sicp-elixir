defmodule Con do
  def cons(x, y) do
    fn (f) -> f.(x, y) end
  end

  def car(c) do
    c.(fn (x, _) -> x end)
  end

  def cdr(c) do
    c.(fn (_, y) -> y end)
  end
end

defmodule Tag do
  import Con

  def pair?(datum) when is_function(datum), do: true
  def pair?(_), do: false

  def attach_tag(type_tag, contents) do
    cons(type_tag, contents)
  end

  def type_tag(datum) do
    if pair?(datum) do
      car(datum)
    else
      raise "Bad tagged datum: CONTENTS"
    end
  end

  def contents(datum) do
    if pair?(datum) do
      cdr(datum)
    else
      raise "Bad tagged datum: CONTENTS"
    end
  end
end

# Implement our own operation-and-type table
defmodule OperationTypeTable do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def put(op, type, item) do
    GenServer.cast(__MODULE__, {:put, op, type, item})
  end

  def get(op, type) do
    GenServer.call(__MODULE__, {:get, op, type})
  end

  # Callback
  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:get, op, type}, _, table) do
    {:reply, Map.get(table, {op, type}), table}
  end

  def handle_cast({:put, op, type, item}, table) do
    if Map.has_key?(table, {op, type}) do
      {:noreply, table}
    else
      {:noreply, Map.put(table, {op, type}, item)}
    end
  end
end

defmodule Rectangular do
  import Tag
  import Con

  # Constructor
  def make_from_real_imag(x, y) do
    cons(x, y)
  end

  def make_from_mag_ang(r, a) do
    cons(r * :math.cos(a), r * :math.sin(a))
  end

  # Selector
  def real_part(z) do
    car(z)
  end

  def image_part(z) do
    cdr(z)
  end

  def magnitude(z) do
    :math.sqrt(:math.pow(real_part(z), 2) + :math.pow(image_part(z), 2))
  end

  def angle(z) do
    :math.atan(
      image_part(z) / real_part(z)
    )
  end

  # Interface to the rest of the system
  def tag(x), do: attach_tag(:rectangular, x)

  def install do
    OperationTypeTable.put(:real_part, :rectangular, &Rectangular.real_part/1)
    OperationTypeTable.put(:image_part, :rectangular, &Rectangular.image_part/1)
    OperationTypeTable.put(:magnitude, :rectangular, &Rectangular.magnitude/1)
    OperationTypeTable.put(:angle, :rectangular, &Rectangular.angle/1)
    OperationTypeTable.put(:make_from_real_imag, :rectangular,
                           fn (x, y) ->
                             tag(make_from_real_imag(x, y))
                           end)
    OperationTypeTable.put(:make_from_mag_ang, :rectangular,
                           fn (x, y) ->
                             tag(make_from_mag_ang(x, y))
                           end)
  end
end

defmodule Polar do
  import Tag
  import Con

  # Constructor
  def make_from_real_imag(x, y) do
    cons(
      :math.sqrt(:math.pow(x, 2) + :math.pow(y, 2)),
      :math.atan(y / x)
    )
  end

  def make_from_mag_ang(r, a) do
    cons(r, a)
  end

  # Selector
  def real_part(z) do
    magnitude(z) * :math.cos(angle(z))
  end

  def image_part(z) do
    magnitude(z) * :math.sin(angle(z))
  end

  def magnitude(z) do
    car(z)
  end

  def angle(z) do
    cdr(z)
  end

  # Interface to the rest of the system
  def tag(x), do: attach_tag(:polar, x)

  def install do
    OperationTypeTable.put(:real_part, :polar, &Polar.real_part/1)
    OperationTypeTable.put(:image_part, :polar, &Polar.image_part/1)
    OperationTypeTable.put(:magnitude, :polar, &Polar.magnitude/1)
    OperationTypeTable.put(:angle, :polar, &Polar.angle/1)
    OperationTypeTable.put(:make_from_real_imag, :polar,
                           fn (x, y) ->
                             tag(make_from_real_imag(x, y))
                           end)
    OperationTypeTable.put(:make_from_mag_ang, :polar,
                           fn (x, y) ->
                             tag(make_from_mag_ang(x, y))
                           end)
  end
end


defmodule Complex do
  import Tag

  def init do
    OperationTypeTable.start_link
    Rectangular.install
    Polar.install
  end

  def apply_generic(op, args) do
    type_tags = type_tag(args)
    proc = OperationTypeTable.get(op, type_tags)
    if proc do
      proc.(contents(args))
    else
      raise "No method for these types: APPLY GENERIC"
    end
  end

  # Generic Selector
  def real_part(z) do
    apply_generic(:real_part, z)
  end

  def image_part(z) do
    apply_generic(:image_part, z)
  end

  def magnitude(z) do
    apply_generic(:magnitude, z)
  end

  def angle(z) do
    apply_generic(:angle, z)
  end

  # Constructor
  def make_from_real_imag(x, y) do
    OperationTypeTable.get(:make_from_real_imag, :rectangular).(x, y)
  end

  def make_from_mag_ang(r, a) do
    OperationTypeTable.get(:make_from_mag_ang, :polar).(r, a)
  end

  # API
  def add_complex(z1, z2) do
    make_from_real_imag(
      real_part(z1) + real_part(z2),
      image_part(z1) + image_part(z2)
    )
  end

  def sub_complex(z1, z2) do
    make_from_real_imag(
      real_part(z1) - real_part(z2),
      image_part(z1) - image_part(z2)
    )
  end

  def mul_complex(z1, z2) do
    make_from_mag_ang(
      magnitude(z1) * magnitude(z2),
      angle(z1) + angle(z2)
    )
  end

  def div_complex(z1, z2) do
    make_from_mag_ang(
      magnitude(z1) / magnitude(z2),
      angle(z1) - angle(z2)
    )
  end
end

Complex.init
c1 = Complex.make_from_mag_ang(10, 20)
c2 = Complex.make_from_real_imag(1,2)

c1 |> Complex.angle |> IO.inspect
c2 |> Complex.angle |> IO.inspect

c1 |> Complex.real_part |> IO.inspect
c2 |> Complex.real_part |> IO.inspect

c3 = Complex.add_complex(c1, c2)

c3 |> Complex.real_part |> IO.inspect
c3 |> Complex.image_part |> IO.inspect
c3 |> Complex.magnitude |> IO.inspect
c3 |> Complex.angle |> IO.inspect


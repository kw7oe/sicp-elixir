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

defmodule Complex do
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

  def polar?(z) do
    type_tag(z) == :polar
  end

  def rectangular?(z) do
    type_tag(z) == :rectangular
  end

  # ======
  # Alyssa
  # ======
  def make_from_real_imag_polar(x, y) do
    attach_tag(:polar,
      cons(
        :math.sqrt(:math.pow(x, 2) + :math.pow(y, 2)),
        :math.atan(y / x)
      )
    )
  end

  def make_from_mag_ang_polar(r, a) do
    attach_tag(:polar, cons(r, a))
  end

  def real_part_polar(z) do
    magnitude_polar(z) * :math.cos(angle_polar(z))
  end

  def image_part_polar(z) do
    magnitude_polar(z) * :math.sin(angle_polar(z))
  end

  def magnitude_polar(z) do
    car(z)
  end

  def angle_polar(z) do
    cdr(z)
  end

  # ===
  # Ben
  # ===
  def make_from_real_imag_rectangular(x, y) do
    attach_tag(:rectangular, cons(x, y))
  end

  def make_from_mag_ang_rectangular(r, a) do
    attach_tag(:rectangular,
      cons(
        r * :math.cos(a),
        r * :math.sin(a)
      )
    )
  end

  def real_part_rectangular(z) do
    car(z)
  end

  def image_part_rectangular(z) do
    cdr(z)
  end

  def magnitude_rectangular(z) do
    :math.sqrt(:math.pow(real_part_rectangular(z), 2) + :math.pow(image_part_rectangular(z), 2))
  end

  def angle_rectangular(z) do
    :math.atan(
      image_part_rectangular(z) / real_part_rectangular(z)
    )
  end

  # Selector
  def real_part(z) do
    cond do
      rectangular?(z) -> real_part_rectangular(contents(z))
      polar?(z) -> real_part_polar(contents(z))
      true -> raise "Unknown type: REAL PART"
    end
  end

  def image_part(z) do
    cond do
      rectangular?(z) -> image_part_rectangular(contents(z))
      polar?(z) -> image_part_polar(contents(z))
      true -> raise "Unknown type: IMAGE PART"
    end
  end

  def magnitude(z) do
    cond do
      rectangular?(z) -> magnitude_rectangular(contents(z))
      polar?(z) -> magnitude_polar(contents(z))
      true -> raise "Unknown type: MAGNITUDE"
    end
  end

  def angle(z) do
    cond do
      rectangular?(z) -> angle_rectangular(contents(z))
      polar?(z) -> angle_polar(contents(z))
      true -> raise "Unknown type: ANGLE"
    end
  end

  def make_from_real_imag(x, y) do
    make_from_real_imag_rectangular(x, y)
  end

  def make_from_mag_ang(r, a) do
    make_from_mag_ang_polar(r, a)
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

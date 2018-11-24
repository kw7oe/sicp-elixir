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

  # ======
  # Alyssa
  # ======
  # def make_from_real_imag(x, y) do
  #   cons(
  #     :math.sqrt(:math.pow(x, 2) + :math.pow(y, 2)),
  #     :math.atan(y / x)
  #   )
  # end

  # def make_from_mag_ang(r, a) do
  #   cons(r, a)
  # end

  # # Selector
  # def real_part(z) do
  #   magnitude(z) * :math.cos(angle(z))
  # end

  # def image_part(z) do
  #   magnitude(z) * :math.sin(angle(z))
  # end

  # def magnitude(z) do
  #   car(z)
  # end

  # def angle(z) do
  #   cdr(z)
  # end

  # ===
  # Ben
  # ===
  def make_from_real_imag(x, y) do
    cons(x, y)
  end

  def make_from_mag_ang(r, a) do
    cons(
      r * :math.cos(a),
      r * :math.sin(a)
    )
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

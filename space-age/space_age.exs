defmodule SpaceAge do
  @type planet ::
          :mercury
          | :venus
          | :earth
          | :mars
          | :jupiter
          | :saturn
          | :uranus
          | :neptune

  @earth_unit 365.25 * 24 * 60 * 60
  @planet_converter %{
    earth: @earth_unit,
    mercury: @earth_unit * 0.2408467,
    venus: @earth_unit * 0.61519726,
    mars: @earth_unit * 1.8808158,
    jupiter: @earth_unit * 11.862615,
    saturn: @earth_unit * 29.447498,
    uranus: @earth_unit * 84.016846,
    neptune: @earth_unit * 164.79132
  }

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet'.
  """
  @spec age_on(planet, pos_integer) :: float
  def age_on(planet, seconds) do
    seconds / @planet_converter[planet]
  end
end

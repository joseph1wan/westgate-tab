# frozen_string_literal: true

class User
  attr_accessor :id, :name, :basic_drinks, :specialty_drinks

  TABLE_NAME = "WestgateDrinkTab"

  def initialize(id, name, basic_drinks, specialty_drinks)
    @id = id
    @name = name
    @basic_drinks = basic_drinks
    @specialty_drinks = specialty_drinks
  end

  def balance
    basic_drinks + (specialty_drinks * 2)
  end

  def update(property, value)
  end
end

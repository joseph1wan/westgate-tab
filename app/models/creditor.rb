# frozen_string_literal: true

class Creditor < ApplicationRecord

  attr_accessor :id, :name, :basic_drinks, :specialty_drinks, :table

  TABLE_NAME = "WestgateDrinkTab"

  def initialize(id, name, basic_drinks, specialty_drinks, table:)
    @id = id
    @name = name
    @basic_drinks = basic_drinks.to_i
    @specialty_drinks = specialty_drinks.to_i
    @table = table
  end

  def self.fields
    %i[name basic_drinks specialty_drinks]
  end

  def to_key
    [id]
  end

  # Helper to generate ID for Turbo
  def dom_id(subtype = nil)
    ActionView::RecordIdentifier.dom_id(self, subtype)
  end

  def drink_count(type)
    case type
    when :basic
      basic_drinks
    when :specialty
      specialty_drinks
    end
  end

  def balance
    basic_drinks.to_i + (specialty_drinks.to_i * 2)
  end

  def add_drink(type)
    case type
    when :basic
      @basic_drinks += 1
    when :specialty
      @specialty_drinks += 1
    end
  end

  def remove_drink(type)
    case type
    when :basic
      @basic_drinks -= 1
    when :specialty
      @specialty_drinks -= 1
    end
  end

  def pay_balance
    @basic_drinks = 0
    @specialty_drinks = 0
  end

  def save
    table.update_row(id, [name, basic_drinks, specialty_drinks])
  end
end

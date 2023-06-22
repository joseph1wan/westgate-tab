# frozen_string_literal: true

module Creditable
  extend ActiveSupport::Concern

  def drink_count(type)
    case type
    when :basic
      self.basic_drinks
    when :specialty
      self.specialty_drinks
    end
  end

  def balance
    self.basic_drinks.to_i + (self.specialty_drinks.to_i * 2)
  end

  def add_drink(type)
    case type
    when :basic
      self.basic_drinks += 1
    when :specialty
      self.specialty_drinks += 1
    end
  end

  def remove_drink(type)
    case type
    when :basic
      self.basic_drinks -= 1
    when :specialty
      self.specialty_drinks -= 1
    end
  end

  def pay_balance
    self.basic_drinks = 0
    self.specialty_drinks = 0
  end
end

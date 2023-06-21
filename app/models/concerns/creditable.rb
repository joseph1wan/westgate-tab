# frozen_string_literal: true

module Creditable
  extend ActiveSupport::Concern

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
end

# frozen_string_literal: true

class Creditor < ApplicationRecord

  attr_accessor :id, :name, :basic_drinks, :specialty_drinks, :table

  # def initialize(id, name, basic_drinks, specialty_drinks, table:)
  #   @id = id
  #   @name = name
  #   @basic_drinks = basic_drinks.to_i
  #   @specialty_drinks = specialty_drinks.to_i
  #   @table = table
  #   binding.pry
  # end

  # Helper to generate ID for Turbo
  def dom_id(subtype = nil)
    ActionView::RecordIdentifier.dom_id(self, subtype)
  end
end

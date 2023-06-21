# frozen_string_literal: true

class GCreditor
  extend ActiveModel::Naming
  include Creditable

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

  def save
    table.update_row(id, [name, basic_drinks, specialty_drinks])
  end
end

# frozen_string_literal: true

class DrinksController < ApplicationController
  def index
    @basic_drinks = Drinks.basic
    @specialty_drinks = Drinks.specialty
  end

  def add_drink
    @name = params[:name]
    @img_url = params[:img_url]
    @creditors = DataConfiguration.instance.creditors
  end

  private

    def load_data
      @data_config ||= DataConfiguration.new
      # values = [
      #   ["Name", "$1 drinks", "$2 drinks"],
      #   ["Joseph", 4, 2],
      #   ["Mang", 1, 0],
      #   ["Klimeks", 3, 2]
      # ]
      # value_range = SheetsDatabase::SHEETS::ValueRange.new(
      #   range: "Sheet1!A1:Z1000",
      #   values: values
      # )
      # DataConfiguration.instance = creditorsTable.new(data: value_range, client: nil)
      DataConfiguration.instance ||= @database.table(Creditor::TABLE_NAME)
    end
end

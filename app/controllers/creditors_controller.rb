# frozen_string_literal: true

class CreditorsController < ApplicationController

  def index
    @creditors = [] #@table.creditors
  end

  def edit
    creditor = @table.find_creditor(params[:id])
    creditor.pay_balance
    if creditor.save
      redirect_to root_path, notice: "Balance paid"
    else
      render :index, status: :unprocessable_entity
    end
  end

  def add_drink
    @creditor = @table.find_creditor(params[:creditor_id])
    @drink_type = params[:type].to_sym
    @creditor.add_drink(@drink_type)
    if @creditor.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      render :index, status: :unprocessable_entity
    end
  end

  def remove_drink
    @creditor = @table.find_creditor(params[:creditor_id])
    @drink_type = params[:type].to_sym
    @creditor.remove_drink(@drink_type)
    if @creditor.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      render :index, status: :unprocessable_entity
    end
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
      # @table = creditorsTable.new(data: value_range, client: nil)
      @table ||= @database.table(Creditor::TABLE_NAME)
    end
end

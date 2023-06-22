# frozen_string_literal: true

class CreditorsController < ApplicationController
  def index
    @creditors = DataConfiguration.instance.creditors
    @creditor = DataConfiguration.instance.new_creditor
  end

  def create
    @creditor = DataConfiguration.instance.new_creditor(creditor_params)
    @creditor.save if @creditor.valid?
    redirect_to root_path
  end

  def edit
    creditor = DataConfiguration.instance.find_creditor(params[:creditor_id])
    creditor.pay_balance
    if creditor.save
      redirect_to root_path, notice: "Balance paid"
    else
      render :index, status: :unprocessable_entity
    end
  end

  def add_drink
    @creditor = DataConfiguration.instance.find_creditor(params[:creditor_id])
    @drink_type = params[:type].to_sym
    @creditor.add_drink(@drink_type)
    if @creditor.save
      respond_to(&:turbo_stream)
    else
      render :index, status: :unprocessable_entity
    end
  end

  def remove_drink
    @creditor = DataConfiguration.instance.find_creditor(params[:creditor_id])
    @drink_type = params[:type].to_sym
    @creditor.remove_drink(@drink_type)
    if @creditor.save
      respond_to(&:turbo_stream)
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
      # DataConfiguration.instance = creditorsTable.new(data: value_range, client: nil)
      DataConfiguration.instance ||= @database.table(Creditor::TABLE_NAME)
    end

    def creditor_params
      params.require(:creditor).permit(:name)
    end
end

# frozen_string_literal: true

class DataConfiguration
  include SheetsDatabase
  include Singleton

  DATA_TYPES = %i[active_record google_sheets].freeze

  attr_accessor :type
  def initialize(type: :active_record)
    @type = type
  end

  def toggle_data_type
    @type = other_type
    if type == :google_sheets
      @database = Database.new(SheetsDatabase.client, ENV["SPREADSHEET_ID"])
    end
  end

  def table
    @database.table(CreditorsTable)
  end


  def other_type
    (DATA_TYPES - [type]).first
  end

  def new_creditor(params = nil)
    case @type
    when :active_record
      params ? Creditor.new(params) : Creditor.new
    when :google_sheets
      # table.creditors
    end
  end

  def creditors
    case @type
    when :active_record
      Creditor.all
    when :google_sheets
      table.creditors
    end
  end

  def find_creditor(id)
    case @type
    when :active_record
      Creditor.find_by_id(id)
    when :google_sheets
      table.find_creditor(id)
    end
  end
end

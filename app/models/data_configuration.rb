# frozen_string_literal: true

class DataConfiguration
  include SheetsDatabase
  include Singleton

  DATA_TYPES = %i[active_record google_sheets].freeze

  attr_accessor :type
  def initialize(type: :active_record)
    @type = type
    if type == :google_sheets
      @database = Database.new(SheetsDatabase.client, ENV["SPREADSHEET_ID"])
      @table = @database.table(Creditor::TABLE_NAME)
    end
  end

  def other_type
    (DATA_TYPES - [type]).first
  end

  def creditors
    case @type
    when :active_record
      Creditor.all
    when :google_sheets
      @table.creditors
    end
  end

  def find_creditor(id)
    case @type
    when :active_record
      Creditor.find_by_id(id)
    when :google_sheets
      @table.find_creditor(id)
    end
  end
end

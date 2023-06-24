# frozen_string_literal: true

module SheetsDatabase
  class Database
    attr_reader :client, :spreadsheet_id

    def initialize(client, spreadsheet_id)
      @client = client
      @spreadsheet_id = spreadsheet_id
    end

    def table_names
      client.spreadsheet(spreadsheet_id).sheets.map(&:properties).map(&:title)
    end

    # Instantiate a Table from API
    def table(model)
      table_name = model::TABLE_NAME
      range = "#{table_name}!A:Z"
      data = client.spreadsheet_values(spreadsheet_id, range)
      model.new(data:, client:)
    end
  end
end

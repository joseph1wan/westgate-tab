# frozen_string_literal: true

module SheetsDatabase
  class Database
    attr_reader :client, :spreadsheet_id, :cache

    def initialize(client, spreadsheet_id)
      @client = client
      @spreadsheet_id = spreadsheet_id
      @cache = {}
    end

    def table_names
      client.spreadsheet(spreadsheet_id).sheets.map(&:properties).map(&:title)
    end

    # Instantiate a Table from cache or from API
    def table(table_name)
      range = "#{table_name}!A:Z"
      last_updated = client.last_updated(spreadsheet_id)
      if Table.table_cached?(table_name) && last_updated < Table.cache_last_updated(table_name)
        table = Table.from_cache(table_name)
      else
        Rails.logger.info("Updating cache")
        data = client.spreadsheet_values(range)
        table = Table.new(table_name: table_name, data: data)
        table.cache_last_updated
        table.cache_data
      end
      table
    end

    def update_table_row(table_name, row, values)

    end
  end
end

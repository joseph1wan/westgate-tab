# frozen_string_literal: true

module SheetsDatabase
  class Client
    attr_reader :sheets, :drive, :spreadsheet_id

    def initialize(sheets_client, drive_client, spreadsheet_id)
      @sheets = sheets_client
      @drive = drive_client
      @spreadsheet_id = spreadsheet_id
    end

    def table_names
      sheets.get_spreadsheet(spreadsheet_id).sheets.map(&:properties).map(&:title)
    end

    # Instantiate a Table from cache or from API
    def table(table_name)
      range = "#{table_name}!A:Z"
      last_updated = drive.get_file(spreadsheet_id, fields: "modified_time").modified_time
      if Table.table_cached?(table_name) && last_updated < Table.cache_last_updated(table_name)
        table = Table.from_cache(table_name)
      else
        Rails.logger.info("Updating cache")
        data = sheets.get_spreadsheet_values(spreadsheet_id, range)
        table = Table.new(table_name: table_name, data: data)
        table.cache_last_updated
        table.cache_data
      end
      table
    end
  end
end

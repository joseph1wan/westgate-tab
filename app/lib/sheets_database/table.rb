# frozen_string_literal: true

module SheetsDatabase
  class Table
    DEFAULT_CELLS = "A:Z".freeze

    def self.from_cache(table_name)
      Table.new(table_name: table_name, data: Rails.cache.read("#{table_name}-cache-data"))
    end

    def self.cache_last_updated(table_name)
      Rails.cache.read("#{table_name}-cache-last_updated")
    end

    def self.table_cached?(table_name)
      Rails.cache.fetch("#{table_name}-cache-last_updated") &&
        Rails.cache.fetch("#{table_name}-cache-data")
    end

    attr_reader :table_name, :data, :client

    def initialize(table_name:, data:, client:)
      @table_name = table_name
      @data = data
      @client = client
    end

    def range(cells = DEFAULT_CELLS)
      "#{table_name}!#{cells}"
    end

    def sync_data(cells = DEFAULT_CELLS)
      @data = client.spreadsheet_values(SPREADSHEET_ID, range(cells))
    end

    def cache_data
      Rails.cache.write("#{table_name}-cache-data", data)
    end

    def cache_last_updated
      Rails.cache.write("#{table_name}-cache-last_updated", Time.now)
    end

    def columns
      data.values.first
    end

    def columns_with_index
      columns.each_with_index.each_with_object({}) do |col_and_ind, result|
        result[col_and_ind.first] = col_and_ind.last
      end
    end

    def rows
      data.values[1..]
    end

    # Find record by ID (id + 1 to account for first row being columns row)
    def row(id)
      id = id.to_i
      raise Exceptions::InvalidRowError, "Row must be a positive integer" unless id.positive?

      rows[id - 1]
    end

    # Find first row matching term in given golumn
    def find(column_name, term)
      column_index = columns_with_index[column_name]
      raise Exceptions::InvalidColumnNameError if column_index.nil?

      index = rows.map { |row| row[column_index] }.index(term)
      rows[index] if index
    end

    # First pass at implementing where. Returns all matching column
    # For now, nil = ""
    def where(column_name, term)
      column_index = columns_with_index[column_name]
      raise Exceptions::InvalidColumnNameError if column_index.nil?

      term = "" if term.nil?

      rows.select do |row|
        value = row[column_index] || ""
        value == term
      end
    end

    def update_row(row, values)
      row = row.to_i
      row += 1
      range = "#{table_name}!#{row}:#{row}" # "Sheet1!2:2"
      client.update_spreadsheet_values(SPREADSHEET_ID, range, [values])
    end
  end
end

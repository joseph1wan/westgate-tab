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

    attr_reader :table_name, :data

    def initialize(table_name:, data:)
      @table_name = table_name
      @data = data
    end

    def range(cells = DEFAULT_CELLS)
      "#{table_name}!#{cells}"
    end

    def sync_data(cells = DEFAULT_CELLS)
      @data = SheetsDatabase.client.spreadsheet_values(SPREADSHEET_ID, range(cells))
    end

    def cache_data
      Rails.cache.write("#{table_name}-cache-data", data)
    end

    def cache_last_updated
      Rails.cache.write("#{table_name}-cache-last_updated", Time.now)
    end

    def columns
      column_map = {}
      data.values.first.each_with_index { |name, index| column_map[name] = index }
      column_map
    end

    def rows
      data.values[1..]
    end

    # Find record by ID (id + 1 to account for first row being columns row)
    def row(id)
      raise Exceptions::InvalidRowError, "Row must be a positive integer" unless id.positive?

      rows[id - 1]
    end

    # Find first row matching term in given golumn
    def find(column_name, term)
      column_index = columns[column_name]
      raise Exceptions::InvalidColumnNameError if column_index.nil?

      index = rows.map { |row| row[column_index] }.index(term)
      rows[index] if index
    end

    # First pass at implementing where. Returns all matching column
    # For now, nil = ""
    def where(column_name, term)
      column_index = columns[column_name]
      raise Exceptions::InvalidColumnNameError if column_index.nil?

      term = "" if term.nil?

      rows.select do |row|
        value = row[column_index] || ""
        value == term
      end
    end
  end
end

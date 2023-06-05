# frozen_string_literal: true

module SheetsDatabase
  class Table
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

    def cache_data
      Rails.cache.write("#{table_name}-cache-data", data)
    end

    def cache_last_updated
      Rails.cache.write("#{table_name}-cache-last_updated", Time.now)
    end
  end
end

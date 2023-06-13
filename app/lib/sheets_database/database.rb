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

    def name_to_model_map
      Table.descendants.each_with_object({}) do |model, result|
        result[model::TABLE_NAME] = model
      end
    end

    # Instantiate a Table from cache or from API
    def table(table_name)
      model = name_to_model_map[table_name]
      if model.nil?
        error_message = "Table #{table_name} not in map. Mapped tables: #{name_to_model_map.keys}. "
        raise Exceptions::InvalidTableNameError, error_message
      end

      range = "#{table_name}!A:Z"
      data = client.spreadsheet_values(spreadsheet_id, range)
      model.new(table_name:, data:, client:)

      # Cache snippet
      # last_updated = client.last_updated(spreadsheet_id)
      # if model.table_cached?(table_name) && last_updated < model.cache_last_updated(table_name)
      #   table = model.from_cache(table_name)
      # else
      #   Rails.logger.info("Updating cache")
        # data = client.spreadsheet_values(spreadsheet_id, range)
        # table = model.new(data:)
        # table.cache_last_updated
        # table.cache_data
      # end
      # table
    end
  end
end

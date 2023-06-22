# frozen_string_literal: true

require "googleauth"

module SheetsDatabase
  class Client
    attr_reader :sheets

    def initialize
      @sheets = Google::Apis::SheetsV4::SheetsService.new
      scopes = %w[https://www.googleapis.com/auth/spreadsheets] # Drive scope: https://www.googleapis.com/auth/drive
      authorization = Google::Auth.get_application_default(scopes) # Use to initiate other clients as necessary
      authorization.expires_in = 1
      @sheets.authorization = authorization
    end

    def last_updated(spreadsheet_id)
      drive.get_file(spreadsheet_id, fields: "modified_time").modified_time
    end

    def spreadsheet(spreadsheet_id)
      sheets.get_spreadsheet(spreadsheet_id)
    end

    def update_spreadsheet_values(spreadsheet_id, range, values)
      handle_errors do
        value_range = SHEETS::ValueRange.new(
          range: range,
          values: values
        )
        sheets.update_spreadsheet_value(spreadsheet_id, range, value_range, value_input_option: "USER_ENTERED")
      end
    end

    def spreadsheet_values(spreadsheet_id, range)
      handle_errors do
        sheets.get_spreadsheet_values(spreadsheet_id, range)
      end
    end

    private

      def handle_errors(&block)
        block.call
      rescue Google::Apis::ClientError => e
        body = JSON.parse(e.body)["error"]
        code = body["code"]
        message = body["message"]
        raise Exceptions::ClientError, "#{code} error: #{message}"
      end
  end
end

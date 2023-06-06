# frozen_string_literal: true

require "googleauth"

module SheetsDatabase
  module ApiClients
    class SheetsClient
      include Singleton

      attr_reader :client

      def initialize
        @client = Google::Apis::SheetsV4::SheetsService.new
        scopes = ["https://www.googleapis.com/auth/spreadsheets"]
        client.authorization = Google::Auth.get_application_default(scopes)
      end
    end
  end
end

# frozen_string_literal: true

module SheetsDatabase
  module ApiClients
    class SheetsClient
      include Singleton

      attr_reader :client

      def initialize
        @client = Google::Apis::SheetsV4::SheetsService.new
        @client.key = ENV["GOOGLE_API_KEY"]
      end
    end
  end
end

# frozen_string_literal: true

module SheetsDatabase
  module ApiClients
    class DriveClient
      include Singleton

      attr_reader :client

      def initialize
        @client = Google::Apis::DriveV3::DriveService.new
        @client.key = ENV["GOOGLE_API_KEY"]
      end
    end
  end
end

# frozen_string_literal: true

module SheetsDatabase
  module ApiClients
    class DriveClient
      include Singleton

      attr_reader :client

      def initialize
        @client = Google::Apis::DriveV3::DriveService.new
        scopes = ["https://www.googleapis.com/auth/drive"]
        client.authorization = Google::Auth.get_application_default(scopes)
      end
    end
  end
end

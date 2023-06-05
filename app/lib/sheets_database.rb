# frozen_string_literal: true
module SheetsDatabase
  def self.client
    sheets_client = ApiClients::SheetsClient.instance.client
    drive_client = ApiClients::DriveClient.instance.client
    @client ||= Client.new(sheets_client, drive_client, ENV["SPREADSHEET_ID"])
  end
end

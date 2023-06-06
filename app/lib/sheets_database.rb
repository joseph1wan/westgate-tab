# frozen_string_literal: true
module SheetsDatabase
  SHEETS = Google::Apis::SheetsV4
  DRIVE = Google::Apis::DriveV3

  SPREADSHEET_ID = Rails.env.production? ? ENV["SPREADSHEET_ID"] : ENV["TEST_SPREADSHEET_ID"]

  def self.client
    sheets_client = ApiClients::SheetsClient.instance.client
    drive_client = ApiClients::DriveClient.instance.client
    @client ||= Client.new(sheets_client, drive_client)
  end
end

# frozen_string_literal: true

require "rails_helper"

module SheetsDatabase
  RSpec.describe Client do
    let(:sheets_client) { ApiClients::SheetsClient.instance.client }
    let(:drive_client) { ApiClients::DriveClient.instance.client }
    let(:spreadsheet_id) { ENV["TEST_SPREADSHEET_ID"] }
    let(:client) { Client.new(sheets_client, drive_client, spreadsheet_id) }

    describe "table_names" do
      it "returns list of tab names" do
        VCR.use_cassette("get_spreadsheet") do
          expect(client.table_names).to match_array(%w[Sheet1 Sheet2 WestgateTabTest])
        end
      end
    end

    describe "table" do
      it "creates a table with values from a spreadsheet" do
        VCR.use_cassette("table_data") do
          table = client.table("WestgateTabTest")
          expect(table).to be_a(Table)
          expect(table.data).to_not be_nil
        end
      end
    end
  end
end

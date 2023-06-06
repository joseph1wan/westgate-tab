# frozen_string_literal: true

require "rails_helper"

module SheetsDatabase
  RSpec.describe Table do
    let(:table) do
      VCR.use_cassette("get_spreadsheet") do
        sheets_client = ApiClients::SheetsClient.instance.client
        drive_client = ApiClients::DriveClient.instance.client
        spreadsheet_id = ENV["TEST_SPREADSHEET_ID"]
        Client.new(sheets_client, drive_client, spreadsheet_id).table_data
      end
    end

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
        end
      end
    end
  end
end

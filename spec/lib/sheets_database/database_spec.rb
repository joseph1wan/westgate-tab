# frozen_string_literal: true

require "rails_helper"

module SheetsDatabase
  RSpec.describe Database do
    describe "table_names" do
      it "returns list of tab names" do
        client = double(SheetsDatabase::Client)
        allow(client).to receive(:spreadsheet) {
          SHEETS::Spreadsheet.from_json(vcr_json("get_spreadsheet"))
        }
        database = Database.new(client, "id")

        expect(database.table_names).to match_array(%w[Sheet1 Sheet2 WestgateTabTest])
      end
    end

    describe "table" do
      before do
        Rails.cache.clear
      end

      it "returns a table with data" do
        client = double(SheetsDatabase::Client)
        allow(client).to receive(:spreadsheet_values) {
          SHEETS::ValueRange.from_json(vcr_json("table_data"))
        }
        allow(client).to receive(:last_updated).and_return(Time.now)
        database = Database.new(client, "id")

        expect(database.table("Sheet1")).to be_a(Table)
      end
    end

    describe "update_table_row" do
      before do
        Rails.cache.clear
      end

      it "updates a table row with new values" do
        client = double(SheetsDatabase::Client)
        allow(client).to receive(:spreadsheet_values) {
          SHEETS::ValueRange.from_json(vcr_json("table_data"))
        }
        allow(client).to receive(:last_updated).and_return(Time.now)
        database = Database.new(client, "id")

        row = 4
        values = ["c", "", "d"]

        expect(database.update_table_row("Sheet1", row, values)).to be_a(Table)
      end
    end
  end
end

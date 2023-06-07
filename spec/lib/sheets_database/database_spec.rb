# frozen_string_literal: true

require "rails_helper"

module SheetsDatabase
  RSpec.describe Database do
    let(:client) { client = double(SheetsDatabase::Client) }

    describe "#table_names" do
      it "returns list of tab names" do
        allow(client).to receive(:spreadsheet) {
          vcr_json_to_model(SHEETS::Spreadsheet, "get_spreadsheet")
        }
        database = Database.new(client, "id")

        expect(database.table_names).to match_array(%w[Sheet1 Sheet2 WestgateTabTest])
      end
    end

    describe "#name_to_model_map" do
      before do
        class TestTable < Table
          TABLE_NAME = "TestTab"
        end
      end

      it "creates a map of table names to models" do
        database = Database.new(client, "id")
        expect(database.map). to eq({ TestTable::TABLE_NAME => TestTable })
      end

    end

    describe "#table" do
      before do
        Rails.cache.clear
      end

      it "returns a table with data" do
        allow(client).to receive(:spreadsheet_values) {
          vcr_json_to_model(SHEETS::ValueRange, "table_data")
        }
        allow(client).to receive(:last_updated).and_return(Time.now)
        database = Database.new(client, "id")

        expect(database.table("Sheet1")).to be_a(Table)
      end
    end

    describe "update_table_row" do
      context "vcr_test" do
        it "updates a table row with new values" do
          VCR.use_cassette("update_table_row") do
            table_name = "UpdateTableRow"
            row = 1
            values = ["Joseph", "joseph.h.wan@gmail.com", 100]
            database = Database.new(SheetsDatabase.client, ENV["TEST_SPREADSHEET_ID"])

            result = database.update_table_row(table_name, row, values)

            expect(result).to be_a(SHEETS::UpdateValuesResponse)
            expect(result.updated_cells).to be_positive
          end
        end
      end
    end
  end
end

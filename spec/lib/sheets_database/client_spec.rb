# frozen_string_literal: true

require "rails_helper"

module SheetsDatabase
  RSpec.describe Client do
    let(:client) { Client.new }

    describe "spreadsheet" do
      it "returns a spreadsheet with values" do
        VCR.use_cassette("get_spreadsheet") do
          result = client.spreadsheet(ENV["TEST_SPREADSHEET_ID"])

          expect(result).to be_a(SHEETS::Spreadsheet)
          expect(result.spreadsheet_id).to eq(ENV["TEST_SPREADSHEET_ID"])
          expect(result.sheets).to_not be_empty
        end
      end
    end

    describe "spreadsheet_values" do
      it "get values from a spreadsheet" do
        VCR.use_cassette("table_data") do
          result = client.spreadsheet_values(ENV["TEST_SPREADSHEET_ID"], "WestgateTabTest!A:Z")

          expect(result).to be_a(SHEETS::ValueRange)
          expect(result.values).to_not be_empty
          expect(result.values.to_json).to include("$1 drinks")
        end
      end
    end

    describe "update_spreadsheet_values" do
      it "update a spreadsheet's values" do
        VCR.use_cassette("update_table_data") do
          range = "Sheet2!A:Z"
          values = [
            ["l", "Col 2", "Col3"],
            ["a", "s"],
            ["b"],
            ["c", "", "d"],
            ["d", "", "b"],
            ["e"]
          ]
          result = client.update_spreadsheet_values(ENV["TEST_SPREADSHEET_ID"], range, values)

          expect(result).to be_a(SHEETS::UpdateValuesResponse)
          expect(result.updated_cells).to be_positive
        end
      end
    end
  end
end

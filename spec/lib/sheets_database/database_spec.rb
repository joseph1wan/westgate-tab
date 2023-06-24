# frozen_string_literal: true

require "rails_helper"

module SheetsDatabase
  RSpec.describe Database do
    let(:client) { client = double(SheetsDatabase::Client) }

    describe "#table_names" do
      it "returns list of tab names" do
        json = {
          "sheets" => [
            {
              "properties" => { "title" => "Sheet1" }
            },
            {
              "properties" => { "title" => "Sheet2" }
            },
            {
              "properties" => { "title" => "Sheet3" }
            }
          ]
        }.to_json
        allow(client).to receive(:spreadsheet).and_return(SHEETS::Spreadsheet.from_json(json))
        database = Database.new(client, "id")

        expect(database.table_names).to match_array(%w[Sheet1 Sheet2 Sheet3])
      end
    end

    context "requires table descendants" do
      describe "#table" do
        it "returns a table with data" do
          allow(client).to receive(:spreadsheet_values) {
            SheetsDatabase::SHEETS::ValueRange.new(
              range: "Sheet1!A1:Z1000",
              values: [
                ["Name", "$1 drinks", "$2 drinks"],
                ["Joseph", 4, 2],
                ["Mang", 2, 0],
                ["Klimeks", 3],
                ["JD", 1, ""]
              ]
            )
          }
          database = Database.new(client, "id")

          expect(database.table(CreditorsTable)).to be_a(Table)
        end
      end
    end
  end
end

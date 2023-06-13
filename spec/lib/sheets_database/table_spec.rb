# frozen_string_literal: true

require "rails_helper"

module SheetsDatabase
  RSpec.describe Table do
    let(:table) do
      Table.new(
        table_name: "Sheet1",
        data: vcr_json_to_model(SHEETS::ValueRange, "table_data"),
        client: nil
      )
    end

    describe "#sync_data" do
      it "retrieves data from source and updates" do
        values = [
          ["Name", "$1 drinks", "$2 drinks"],
          ["Joseph", 4, 2],
          ["Mang", 1, 0],
          ["Klimeks", 3, 2]
        ]
        value_range = SheetsDatabase::SHEETS::ValueRange.new(
          range: "Sheet1!A1:Z1000",
          values: values
        )
        client = double(SheetsDatabase.client)
        allow(client).to receive(:spreadsheet_values).and_return(value_range)
        allow(table).to receive(:client).and_return(client)

        expect { table.sync_data }.to change { table.data }
      end
    end

    describe "columns" do
      it "returns hash of columns and column index" do
        column_map = table.columns
        expected_columns = {
          "l" => 0,
          "Col 2" => 1,
          "Col3" => 2
        }

        expect(column_map).to eq(expected_columns)
      end
    end

    describe "row" do
      it "returns row by id" do
        expected_row = ["c", "", "d"]

        expect(table.row(3)).to eq(expected_row)
      end
    end

    describe "find" do
      context "target exists" do
        it "returns row by column_name and search term" do
          expected_row = ["c", "", "d"]

          expect(table.find("Col3", "d")).to eq(expected_row)
        end
      end

      context "target doesn't exist" do
        it "returns row by column_name and search term" do
          expect(table.find("Col3", "")).to eq(nil)
        end
      end
    end

    describe "where" do
      context "search nil value" do
        it "returns rows with empty cells when term is empty string" do
          expected = [
            ["a", "s"],
            ["b"],
            ["e"]
          ]

          expect(table.where("Col3", "")).to eq(expected)
        end

        it "returns rows with empty cells when term is nil" do
          expected = [
            ["a", "s"],
            ["b"],
            ["e"]
          ]

          expect(table.where("Col3", nil)).to eq(expected)
        end
      end
    end
  end
end

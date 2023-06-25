# frozen_string_literal: true

require "rails_helper"

module SheetsDatabase
  RSpec.describe Table do
    let(:columns) { ["Name", "$1 drinks", "$2 drinks"] }
    let(:rows) { [["Joseph", 4, 2], ["Mang", 2, 0], ["Klimeks", 3], ["JD", 1, ""]] }
    let(:table_data) do
      SheetsDatabase::SHEETS::ValueRange.new(
        range: "Sheet1!A1:Z1000",
        values: [columns] + rows
      )
    end
    let(:table) do
      Table.new(
        table_name: "Sheet1",
        data: table_data,
        client: nil
      )
    end

    describe "#sync_data" do
      it "retrieves data from source and updates" do
        client = double(Client)
        new_data = SheetsDatabase::SHEETS::ValueRange.new(
          range: "Sheet1!A1:Z1000",
          values: [["Name"], ["Joseph"]]
        )
        allow(client).to receive(:spreadsheet_values).and_return(new_data)
        allow(table).to receive(:client).and_return(client)

        expect { table.sync_data }.to change { table.data }
      end
    end

    describe "#columns_with_index" do
      it "returns hash of columns and column index" do
        expected_columns = {
          "Name" => 0,
          "$1 drinks" => 1,
          "$2 drinks" => 2,
        }
        expect(table.columns_with_index).to eq(expected_columns)
      end
    end

    describe "row" do
      it "returns row by id" do
        row_num = 1
        expected_row = rows[row_num - 1] # Account for column row

        expect(table.row(row_num)).to eq(expected_row)
      end
    end

    describe "find" do
      context "target exists" do
        it "returns row by column_name and search term" do
          column = columns[0]
          search = rows[1][0]
          expected_row = rows[1]

          expect(table.find(column, search)).to eq(expected_row)
        end
      end

      context "target doesn't exist" do
        it "returns row by column_name and search term" do
          expect(table.find(columns[1], "")).to eq(nil)
        end
      end
    end

    describe "where" do
      context "search nil value" do
        it "returns rows with empty cells when term is empty string" do
          expected_rows = rows[2..]

          expect(table.where(columns[-1], "")).to eq(expected_rows)
        end

        it "returns rows with empty cells when term is nil" do
          expected_rows = rows[2..]

          expect(table.where(columns[-1], "")).to eq(expected_rows)
        end
      end
    end
  end
end

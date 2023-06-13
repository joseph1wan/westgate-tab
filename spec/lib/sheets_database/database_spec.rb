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

    context "requires table descendants" do
      before(:context) do
        class TestTable < Table
          TABLE_NAME = "TestTab"
        end
      end

      before(:each) do
        allow(Table).to receive(:descendants).and_return([TestTable])
      end

      describe "#name_to_model_map" do
        it "creates a map of table names to models" do
          database = Database.new(client, "id")
          expect(database.name_to_model_map). to eq({ TestTable::TABLE_NAME => TestTable })
        end
      end

      describe "#table" do
        # before do
        #   Rails.cache.clear
        # end

        it "returns a table with data" do
          allow(client).to receive(:spreadsheet_values) {
            vcr_json_to_model(SHEETS::ValueRange, "table_data")
          }
          allow(client).to receive(:last_updated).and_return(Time.now)
          database = Database.new(client, "id")

          expect(database.table(TestTable::TABLE_NAME)).to be_a(Table)
        end
      end
    end
  end
end

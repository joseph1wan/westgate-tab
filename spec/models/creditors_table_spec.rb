# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreditorsTable do
  describe "#creditors" do
    it "returns an array of creditor models" do
      values = [
        ["Name", "$1 drinks", "$2 drinks"],
        ["Joseph", 4, 2],
        ["Mang", 1, 0],
        ["Klimeks", 3, 2]
      ]
      value_range = SheetsDatabase::SHEETS::ValueRange.new(
        range: "Sheet1!A1:Z1000",
        values:
      )
      creditors_table = creditorsTable.new(data: value_range, client: nil)
      creditors = creditors_table.creditors

      expect(creditors.length).to eq(values[1..].length)
      expect(creditors.map(&:name)).to match_array(values[1..].map(&:first))
    end
  end
end

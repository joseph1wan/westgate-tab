# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersTable do
  describe "#users" do
    it "returns an array of User models" do
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
      users_table = UsersTable.new(data: value_range)
      users = users_table.users

      expect(users.length).to eq(values[1..].length)
      expect(users.map(&:name)).to match_array(values[1..].map(&:first))
    end
  end
end

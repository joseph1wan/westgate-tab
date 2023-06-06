# frozen_string_literal: true

class UsersTable < SheetsDatabase::Table
  TABLE_NAME = "WestgateDrinkTab"

  def initialize(data:)
    super(table_name: TABLE_NAME, data:)
  end

  def users
    rows.each_with_index.map { |attrs, index| User.new(index, *attrs) }
  end
end

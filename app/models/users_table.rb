# frozen_string_literal: true

class UsersTable < SheetsDatabase::Table
  TABLE_NAME = "WestgateDrinkTab"

  def initialize(data:, client:)
    super(table_name: TABLE_NAME, data:, client:)
  end

  def rows
    super.map { |row| format_row(row) }
  end

  def find_user(id)
    User.new(id, *row(id), table: self)
  end

  def users
    rows.each_with_index.map { |attrs, index| User.new(index + 1, *attrs, table: self) }
  end

  private

    def format_row(row)
      if row.length < User.fields.length
        format_row(row.append(""))
      end
      row
    end
end

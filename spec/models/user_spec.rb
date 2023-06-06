# frozen_string_literal: true

require "rails_helper"

RSpec.describe Table do
  let(:table) do
    Table.new(
      table_name: "Sheet1",
      data: vcr_json_to_model(SHEETS::ValueRange, "table_data")
    )
  end
end

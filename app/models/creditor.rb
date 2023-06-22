# frozen_string_literal: true

class Creditor < ApplicationRecord
  include Creditable

  # Helper to generate ID for Turbo
  def dom_id(subtype = nil)
    ActionView::RecordIdentifier.dom_id(self, subtype)
  end
end

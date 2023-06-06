# frozen_string_literal: true

module Helpers
  def vcr_json(filename)
    json = JSON.parse(File.read("spec/cassettes/#{filename}.json"))
    json["http_interactions"].first["response"]["body"]["string"]
  end
end

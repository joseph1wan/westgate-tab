# frozen_string_literal: true

module Helpers
  def vcr_json_to_model(model, filename)
    json = JSON.parse(File.read("spec/cassettes/#{filename}.json"))
    data = json["http_interactions"].first["response"]["body"]["string"]
    model.from_json(data)
  end
end

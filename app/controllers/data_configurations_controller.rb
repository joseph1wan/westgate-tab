class DataConfigurationsController < ApplicationController
  def update
    DataConfiguration.instance.toggle_data_type
  end
end

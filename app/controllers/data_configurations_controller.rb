class DataConfigurationsController < ApplicationController
  def update
    DataConfiguration.instance.toggle_data_type
    redirect_to root_path
  end
end

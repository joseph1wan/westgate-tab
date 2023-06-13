class DataConfigurationsController < ApplicationController
  def update
    DataConfiguration.instance.type = params[:type].to_sym
  end
end

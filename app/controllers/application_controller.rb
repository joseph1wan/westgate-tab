class ApplicationController < ActionController::Base
  include SheetsDatabase

  before_action :database

  def database
    @database ||= Database.new(SheetsDatabase.client, ENV["SPREADSHEET_ID"])
  end
end

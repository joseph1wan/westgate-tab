# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    table = @database.table(UsersTable::TABLE_NAME)
    @users = table.users
  end
end

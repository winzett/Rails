class UserItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_items = current_user.user_items
  end
end

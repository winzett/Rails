class ApplicationController < ActionController::Base
  def get_cart
    current_user.orders.cart.first_or_create
  end
end

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_object, only: [:update, :show, :edit]
  before_action :check_owner, only: [:edit, :show, :update]

  def index
    @orders = current_user.orders.order(:paid_at)
  end

  def edit

  end

  def new
    @order = get_cart
  end

  def update
    @order.paid!
    @order.update(paid_at: Time.now)
    redirect_to @order
  end

  private
    def load_object
      @order = Order.find params[:id]
    end

    def check_owner
      redirect_to root_path unless @order.user == current_user
    end
end

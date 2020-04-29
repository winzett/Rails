class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_object, only: [:show, :toggle, :add, :edit, :update, :destroy]
  before_action :check_owner, only: [:edit, :update, :destroy]

  def index
    if params[:type] == "selling"
      redirect_to root_path
      @items = current_user.items
    else
      @items = Item.all
      if params[:category_id].present?
        @category = Category.find(params[:category_id])
        @items = @items.where(category_id: params[:category_id])
      end
      # @items = params[:order].blank? ?  @item.order(created_at: :desc) : @items.order(params[:order])
      @items = @items.ransack(title_or_description_cont: params[:q]).result(distinct: true) if params[:q].present?
    end
  end

  def show
  end

  def add
    @order = get_cart
    line_item = @order.line_items.where(item: @item).first_or_create(price: @item.price)
    line_item.increment!(:amount)
    line_item.set_order_total
    redirect_to new_order_path
  end

  def toggle
    if user_item = current_user.user_items.where(item: @item).first
      user_item.destroy
    else
      current_user.user_items.where(item: @item).create
    end
    redirect_to @item
  end

  def edit

  end

  def update
    @item.update(item_params)
    redirect_to item_path
  end

  def destroy
    @item.destroy
    redirect_back fallback_location: root_path
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.create(item_params)
    @item.update(user: current_user)
    redirect_to items_path(type: :selling)
  end

  private
    def load_object
      @item = Item.find params[:id]
    end

    def item_params
      params.require(:item).permit(:user_id, :title, :price, :description, :iamge, :category_id)
    end

    def check_owner
      redirect_to root_path unless @item.user == current_user
    end
end

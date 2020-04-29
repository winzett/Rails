class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :item, optional: true

  after_save :set_order_total

  def set_order_total
    order.update(total: order.line_items.sum("amount * price"))
  end
end

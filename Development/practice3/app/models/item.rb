class Item < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :category, optional: true

  mount_uploader :image, ImageUploader

  has_many :line_items, dependent: :nullify
  has_many :line_items, dependent: :destroy

  def self.generate_items
    %w(
      파리
      로마
      뉴욕
      런던
      다낭
      자카르타
      베이징
      도쿄
    ).each do |title|
      category = Category.fourth
      Item.create(title: title, price: 2000000, category: category, image: Item.first.image, user: User.first)
    end
  end
end

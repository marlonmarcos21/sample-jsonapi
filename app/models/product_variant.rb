# t.string     :name
# t.decimal    :price
# t.boolean    :active,         default: true
# t.integer    :stock
# t.integer    :sold_count
# t.references :product
# t.references :product_option
# t.integer    :weight,         default: 0

class ProductVariant < ActiveRecord::Base
  belongs_to :product
  belongs_to :product_option

  validates :name,    presence: true
  validates :price,   presence: true
  validates :product, presence: true

  has_paper_trail on: :update
end

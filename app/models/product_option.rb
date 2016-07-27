# t.string     :name
# t.decimal    :price
# t.boolean    :active,    default: true
# t.integer    :stock
# t.integer    :sold_count
# t.references :product
# t.integer    :weight,    default: 0

class ProductOption < ActiveRecord::Base
  belongs_to :product

  has_many :product_variants, dependent: :destroy

  validates :name,    presence: true
  validates :price,   presence: true
  validates :product, presence: true

  has_paper_trail on: :update

  scope :ascending_weight, -> { order(:weight) }
end

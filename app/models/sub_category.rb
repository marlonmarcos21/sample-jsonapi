# t.string     :name
# t.integer    :weight,  default: 0
# t.boolean    :active,  default: :true
# t.references :category

class SubCategory < ActiveRecord::Base
  belongs_to :category

  has_and_belongs_to_many :products

  validates :name, presence: true

  scope :actives,    -> { where(active: true) }
  scope :descending, -> { order(weight: :desc) }

  delegate :name, to: :category, prefix: true

  class << self
    def in_categories(*category_ids)
      joins(:category)
        .where(categories: { id: category_ids })
    end
  end

  def total_products_count
    Rails.cache.fetch("sub_category/#{id}/total_products_count", expires_in: 24.hours) do
      products.actives.not_finished.count
    end
  end
end

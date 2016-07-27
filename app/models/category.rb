# t.string  :name
# t.integer :weight, default: 0
# t.boolean :active, default: :true

class Category < ActiveRecord::Base
  has_many :sub_categories

  has_and_belongs_to_many :products, join_table: :products_categories

  accepts_nested_attributes_for :sub_categories,
                                reject_if: proc { |attrs| attrs['name'].blank? },
                                allow_destroy: true

  validates :name, presence: true

  scope :actives,    -> { where(active: true) }
  scope :descending, -> { order(weight: :desc) }

  def total_products_count
    Rails.cache.fetch("category/#{id}/total_products_count", expires_in: 24.hours) do
      products.actives.not_finished.count
    end
  end
end

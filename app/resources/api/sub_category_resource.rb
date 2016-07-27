class Api::SubCategoryResource < JSONAPI::Resource
  paginator :none

  attributes :name, :active, :weight, :total_products_count

  has_one :category

  has_many :products
end

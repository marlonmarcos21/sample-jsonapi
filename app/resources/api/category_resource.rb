class Api::CategoryResource < JSONAPI::Resource
  paginator :none

  attributes :name, :weight, :active, :total_products_count

  has_many :sub_categories
  has_many :products
end

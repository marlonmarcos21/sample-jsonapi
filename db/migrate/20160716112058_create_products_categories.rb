class CreateProductsCategories < ActiveRecord::Migration
  def change
    create_table :products_categories do |t|
      t.references :product,  index: true
      t.references :category, index: true
    end
  end
end

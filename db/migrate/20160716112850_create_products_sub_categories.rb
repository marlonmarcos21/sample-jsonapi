class CreateProductsSubCategories < ActiveRecord::Migration
  def change
    create_table :products_sub_categories do |t|
      t.references :product,      index: true
      t.references :sub_category, index: true
    end
  end
end

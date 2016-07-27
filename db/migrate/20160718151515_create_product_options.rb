class CreateProductOptions < ActiveRecord::Migration
  def change
    create_table :product_options do |t|
      t.string     :name
      t.decimal    :price,      precision: 8, scale: 2
      t.boolean    :active,     default: true
      t.integer    :stock
      t.integer    :sold_count, default: 0
      t.references :product,    index: true
      t.integer    :weight,     default: 0

      t.timestamps null: false
    end
  end
end

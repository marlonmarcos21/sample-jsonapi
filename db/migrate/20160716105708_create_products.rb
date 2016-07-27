class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string   :name
      t.string   :description
      t.text     :tnc
      t.decimal  :price,      precision: 8, scale: 2
      t.boolean  :active,     default: false
      t.datetime :published_at
      t.boolean  :finished,   default: false
      t.datetime :finished_at
      t.integer  :stock
      t.integer  :sold_count, default: 0
      t.string   :slug,       index: true
      t.integer  :weight,     default: 0

      t.timestamps null: false
    end
  end
end

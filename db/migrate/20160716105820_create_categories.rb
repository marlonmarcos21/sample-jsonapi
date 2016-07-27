class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string  :name
      t.integer :weight, default: 0
      t.boolean :active, default: :true
    end
  end
end

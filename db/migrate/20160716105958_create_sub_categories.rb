class CreateSubCategories < ActiveRecord::Migration
  def change
    create_table :sub_categories do |t|
      t.string     :name
      t.integer    :weight,   default: 0
      t.boolean    :active,   default: :true
      t.references :category, index: true
    end
  end
end

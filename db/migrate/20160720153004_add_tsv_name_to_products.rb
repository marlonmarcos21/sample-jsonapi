class AddTsvNameToProducts < ActiveRecord::Migration
  def up
    add_column :products, :tsv_name, :tsvector
    add_index  :products, :tsv_name, using: 'gin'

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON products FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv_name, 'pg_catalog.english', name
      );
    SQL

    now = Time.zone.now.to_s(:db)
    update("UPDATE products SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON products
    SQL

    remove_index  :products, :tsv_name
    remove_column :products, :tsv_name
  end
end

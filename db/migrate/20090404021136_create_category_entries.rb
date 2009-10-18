class CreateCategoryEntries < ActiveRecord::Migration
  def self.up
    create_table :category_entries do |t|
      t.integer :entry_id
      t.integer :category_id
      t.timestamps
    end
  end

  def self.down
    drop_table :category_entries
  end
end

class CreateTagEntries < ActiveRecord::Migration
  def self.up
    create_table :tag_entries do |t|
      t.integer :entry_id
      t.integer :tag_id
      t.timestamps
    end
  end

  def self.down
    drop_table :tag_entries
  end
end

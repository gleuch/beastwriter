class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :parent_id, :default => 0
      t.string :name, :limit => 50
      t.string :permalink, :limit => 50
      t.string :description, :limit => 300
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end

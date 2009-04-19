class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :name, :limit => 50
      t.string :url, :limit => 100
      t.datetime :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end

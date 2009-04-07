class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name, :limit => 50
      t.string :permalink, :limit => 50
      t.string :description, :limit => 300
      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end

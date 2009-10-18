class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.string :user_id
      t.string :title, :limit => 250
      t.string :permalink, :limit => 250
      t.datetime :publish_at
      t.string :content
      t.string :content_parsed
      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end

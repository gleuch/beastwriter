class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :post_id
      t.string :alias
      t.string :ip
      t.string :website
      t.string :email
      t.string :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end

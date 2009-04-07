class AddDeletedToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :deleted_at, :datetime
  end

  def self.down
    remove_column :comments, :deleted_at
  end
end

class AlterCommentsFields < ActiveRecord::Migration
  def self.up
    rename_column :comments, :alias, :author
    rename_column :comments, :website, :author_url
    rename_column :comments, :email, :author_email
    rename_column :comments, :comment, :content
    rename_column :comments, :ip, :user_ip
    add_column :comments, :user_agent, :string, :limit => 500
  end

  def self.down
    rename_column :comments, :author, :alias
    rename_column :comments, :author_url, :website
    rename_column :comments, :author_email, :email
    rename_column :comments, :content, :comment
    rename_column :comments, :user_ip, :ip
    remove_column :comments, :user_agent
  end
end

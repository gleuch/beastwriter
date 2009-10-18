class CreateSchema < ActiveRecord::Migration
  def self.up
    # Forum Brain Buster (still not sure this is needed)
    create_table :brain_busters, :force => true do |t|
      t.string :question
      t.string :answer
    end

    # Blog Categories
    create_table :categories do |t|
      t.integer :parent_id, :default => 0
      t.string :name, :limit => 50
      t.string :permalink, :limit => 50
      t.string :description, :limit => 300
      t.timestamps
    end

    # Blog Entry in Categories
    create_table :category_entries do |t|
      t.integer :entry_id
      t.integer :category_id
      t.timestamps
    end

    # Blog Comments
    create_table :comments do |t|
      t.integer :entry_id
      t.string :author
      t.string :user_ip
      t.string :author_url
      t.string :author_email
      t.string :content
      t.datetime :deleted_at
      t.string :user_agent,   :limit => 500
      t.timestamps
    end

    # Blog Entries
    create_table :entries do |t|
      t.string :user_id
      t.string :title, :limit => 250
      t.string :permalink, :limit => 250
      t.datetime :publish_at
      t.string :content
      t.string :content_parsed
      t.timestamps
    end

    # Forum Forums
    create_table :forums, :force => true do |t|
      t.integer :site_id
      t.string  :name
      t.string  :description
      t.integer :topics_count,     :default => 0
      t.integer :posts_count,      :default => 0
      t.integer :position,         :default => 0
      t.text    :description_html
      t.string  :state,            :default => 'public'
      t.string  :permalink
    end

    # Blog links
    create_table :links do |t|
      t.string :name, :limit => 50
      t.string :url, :limit => 100
      t.datetime :deleted_at
      t.timestamps
    end

    # Forum Posts
    create_table :posts, :force => true do |t|
      t.integer  :user_id
      t.integer  :topic_id
      t.text     :body
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :forum_id
      t.text     :body_html
      t.integer  :site_id
    end

    # Site-wide roles
    create_table :roles do |t|
      t.string :name
    end
    
    # Site-wide User in Roes
    create_table :roles_users, :id => false do |t|
      t.integer :role_id
      t.integer :user_id
    end

    # Forum sites
    create_table :sites, :force => true do |t|
      t.string   :name
      t.string   :host
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :topics_count, :default => 0
      t.integer  :users_count,  :default => 0
      t.integer  :posts_count,  :default => 0
      t.text     :description
      t.text     :tagline
    end

    # Forum Topics
    create_table :topics, :force => true do |t|
      t.integer  :forum_id
      t.integer  :user_id
      t.string   :title
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :hits,            :default => 0
      t.integer  :sticky,          :default => 0
      t.integer  :posts_count,     :default => 0
      t.boolean  :locked,          :default => false
      t.integer  :last_post_id
      t.datetime :last_updated_at
      t.integer  :last_user_id
      t.integer  :site_id
      t.string   :permalink
    end

    # Blog Tags
    create_table :tags do |t|
      t.string :name, :limit => 50
      t.string :permalink, :limit => 50
      t.string :description, :limit => 300
      t.timestamps
    end

    # Blog Entry in Tags
    create_table :tag_entries do |t|
      t.integer :entry_id
      t.integer :tag_id
      t.timestamps
    end


    # Site-wide users
    create_table :users, :force => true do |t|
      t.string   :login
      t.string   :email
      t.string   :crypted_password,           :limit => 40
      t.string   :salt,                       :limit => 40
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :activation_code,            :limit => 40
      t.datetime :activated_at
      t.string   :state,                      :default => 'passive'
      t.datetime :deleted_at
      t.boolean  :admin,                      :default => false
      t.integer  :site_id
      t.datetime :last_login_at
      t.text     :bio_html
      t.string   :openid_url
      t.datetime :last_seen_at
      t.string   :website
      t.integer  :posts_count,                :default => 0
      t.string   :bio
      t.string   :display_name
      t.string   :permalink
    end

    # Indexes
    add_index :forums, ['position', 'site_id'], :name => 'index_forums_on_position_and_site_id'
    add_index :forums, ['site_id', 'permalink'], :name => 'index_forums_on_site_id_and_permalink'

    add_index :posts, ['created_at', 'forum_id'], :name => 'index_posts_on_forum_id'
    add_index :posts, ['created_at', 'topic_id'], :name => 'index_posts_on_topic_id'
    add_index :posts, ['created_at', 'user_id'], :name => 'index_posts_on_user_id'

    add_index :roles_users, :role_id, :name => 'index_roles'
    add_index :roles_users, :user_id, :name => 'index_users'

    add_index :topics, ['forum_id', 'permalink'], :name => 'index_topics_on_forum_id_and_permalink'
    add_index :topics, ['last_updated_at', 'forum_id'], :name => 'index_topics_on_forum_id_and_last_updated_at'
    add_index :topics, ['sticky', 'last_updated_at', 'forum_id'], :name => 'index_topics_on_sticky_and_last_updated_at'

    add_index :users, ['last_seen_at'], :name => 'index_users_on_last_seen_at'
    add_index :users, ['site_id', 'permalink'], :name => 'index_site_users_on_permalink'
    add_index :users, ['site_id', 'posts_count'], :name => 'index_site_users_on_posts_count'


  end

  def self.down
    drop_table :brain_busters
    drop_table :categories
    drop_table :category_entries
    drop_table :comments
    drop_table :entries
    drop_table :forums
    drop_table :links
    drop_table :posts
    drop_table :roles
    drop_table :roles_users
    drop_table :sites
    drop_table :topics
    drop_table :tags
    drop_table :tag_entries
    drop_table :users
  end
end

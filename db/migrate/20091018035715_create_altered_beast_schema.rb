class CreateAlteredBeastSchema < ActiveRecord::Migration
  def self.up

    create_table :forums, :force => true do |t|
      t.integer :site_id
      t.string  :name
      t.string  :description
      t.integer :topics_count,     :default => 0
      t.integer :posts_count,      :default => 0
      t.integer :position,         :default => 0
      t.text    :description_html
      t.string  :state,            :default => "public"
      t.string  :permalink
    end

    add_index :forums, ["position", "site_id"], :name => "index_forums_on_position_and_site_id"
    add_index :forums, ["site_id", "permalink"], :name => "index_forums_on_site_id_and_permalink"

    create_table :moderatorships, :force => true do |t|
      t.integer  :forum_id
      t.integer  :user_id
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :monitorships, :force => true do |t|
      t.integer  :user_id
      t.integer  :topic_id
      t.datetime :created_at
      t.datetime :updated_at
      t.boolean  :active,     :default => true
    end

    create_table :open_id_authentication_associations, :force => true do |t|
      t.binary  :server_url
      t.string  :handle
      t.binary  :secret
      t.integer :issued
      t.integer :lifetime
      t.string  :assoc_type
    end

    create_table :open_id_authentication_nonces, :force => true do |t|
      t.string  :nonce
      t.integer :created
    end

    create_table :open_id_authentication_settings, :force => true do |t|
      t.string :setting
      t.binary :value
    end

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

    add_index :posts, ["created_at", "forum_id"], :name => "index_posts_on_forum_id"
    add_index :posts, ["created_at", "topic_id"], :name => "index_posts_on_topic_id"
    add_index :posts, ["created_at", "user_id"], :name => "index_posts_on_user_id"

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

    add_index :topics, ["forum_id", "permalink"], :name => "index_topics_on_forum_id_and_permalink"
    add_index :topics, ["last_updated_at", "forum_id"], :name => "index_topics_on_forum_id_and_last_updated_at"
    add_index :topics, ["sticky", "last_updated_at", "forum_id"], :name => "index_topics_on_sticky_and_last_updated_at"

    create_table :users, :force => true do |t|
      t.string   :login
      t.string   :email
      t.string   :crypted_password,          :limit => 40
      t.string   :salt,                      :limit => 40
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :activation_code,           :limit => 40
      t.datetime :activated_at
      t.string   :state,                                   :default => "passive"
      t.datetime :deleted_at
      t.boolean  :admin,                                   :default => false
      t.integer  :site_id
      t.datetime :last_login_at
      t.text     :bio_html
      t.string   :openid_url
      t.datetime :last_seen_at
      t.string   :website
      t.integer  :posts_count,                             :default => 0
      t.string   :bio
      t.string   :display_name
      t.string   :permalink
    end

    add_index :users, ["last_seen_at"], :name => "index_users_on_last_seen_at"
    add_index :users, ["site_id", "permalink"], :name => "index_site_users_on_permalink"
    add_index :users, ["site_id", "posts_count"], :name => "index_site_users_on_posts_count"
  end

  def self.down
    drop_table :forums
    drop_table :moderatorships
    drop_table :monitorships
    drop_table :open_id_authentication_associations
    drop_table :open_id_authentication_nonces
    drop_table :open_id_authentication_settings
    drop_table :posts
    drop_table :sites
    drop_table :topics
    drop_table :users
  end
end

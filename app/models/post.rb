class Post < ActiveRecord::Base
  include User::Editable
  
  formats_attributes :body

  # author of post
  belongs_to :user, :counter_cache => true
  
  belongs_to :topic, :counter_cache => true
  
  # topic's forum (set by callback)
  belongs_to :forum, :counter_cache => true
  
  # topic's site (set by callback)
  belongs_to :site, :counter_cache => true
  
  validates_presence_of :user_id, :site_id, :topic_id, :forum_id, :body
  validate :topic_is_not_locked

  after_create  :update_cached_fields
  after_destroy :update_cached_fields

  attr_accessible :body

  def forum_name
    forum.name
  end

  def self.search(query, options = {})
  # had to change the other join string since it conflicts when we bring parents in
    options[:conditions] ||= ["LOWER(#{Post.table_name}.body) LIKE ?", "%#{query}%"] unless query.blank?
    options[:select]     ||= "#{Post.table_name}.*, #{Topic.table_name}.title as topic_title, f.name as forum_name"
    options[:joins]      ||= "inner join #{Topic.table_name} on #{Post.table_name}.topic_id = #{Topic.table_name}.id " + 
                             "inner join #{Forum.table_name} as f on #{Topic.table_name}.forum_id = f.id"
    options[:order]      ||= "#{Post.table_name}.created_at DESC"
    options[:count]      ||= {:select => "#{Post.table_name}.id"}
    paginate options
  end

protected
  def update_cached_fields
    topic.update_cached_post_fields(self)
  end
  
  def topic_is_not_locked
    errors.add_to_base("Topic is locked") if topic && topic.locked? && topic.posts_count > 0
  end
end

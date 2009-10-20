class ForumPost < ActiveRecord::Base
  # include User::Editable
  
  formats_attributes :body
  
  validates_presence_of :user_id, :forum_thread_id, :forum_id, :body
  validate :thread_is_not_locked

  after_create  :update_cached_fields
  after_destroy :update_cached_fields

  belongs_to :user, :counter_cache => true
  belongs_to :thread, :class_name => 'ForumThread', :foreign_key => 'forum_thread_id', :counter_cache => true
  belongs_to :forum_thread
  belongs_to :forum, :counter_cache => true

  attr_accessible :body



  def forum_name; forum.name; end

  def self.search(query, options = {})
  # had to change the other join string since it conflicts when we bring parents in
    options[:conditions] ||= ["LOWER(#{ForumPost.table_name}.body) LIKE ?", "%#{query}%"] unless query.blank?
    options[:select]     ||= "#{ForumPost.table_name}.*, #{ForumThread.table_name}.title as thread_title, f.name as forum_name"
    options[:joins]      ||= "inner join #{ForumThread.table_name} on #{ForumPost.table_name}.forum_thread_id = #{ForumThread.table_name}.id " + 
                             "inner join #{Forum.table_name} as f on #{ForumThread.table_name}.forum_id = f.id"
    options[:order]      ||= "#{ForumPost.table_name}.created_at DESC"
    options[:count]      ||= {:select => "#{ForumPost.table_name}.id"}
    paginate options
  end


  def editable_by?(user, is_moderator = nil)
    is_moderator = false#user.moderator_of?(forum) if is_moderator.nil?
    user && (user.id == user_id || is_moderator)
  end

protected

  def update_cached_fields; thread.update_cached_post_fields(self); end
  def thread_is_not_locked; errors.add_to_base("Thread is locked") if thread && thread.locked? && thread.forum_posts_count > 0; end

end
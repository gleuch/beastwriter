class Forum < ActiveRecord::Base
  formats_attributes :description
  acts_as_list

  validates_presence_of :name
  has_permalink :name


  has_many :threads, :class_name => 'ForumThread', :order => "#{ForumThread.table_name}.sticky desc, #{ForumThread.table_name}.last_updated_at desc", :dependent => :delete_all

  # this is used to see if a forum is "fresh"... we can't use threads because it puts
  # stickies first even if they are not the most recently modified
  has_many :recent_threads, :class_name => 'ForumThread', :include => [:user],
    :order => "#{ForumThread.table_name}.last_updated_at DESC",
    :conditions => ["users.state == ?", "active"]
  has_one  :recent_thread,  :class_name => 'ForumThread', :order => "#{ForumThread.table_name}.last_updated_at DESC"

  has_many :posts, :class_name => 'ForumPost', :order => "#{ForumPost.table_name}.created_at DESC", :dependent => :delete_all
  has_one  :recent_post, :class_name => 'ForumPost', :order => "#{ForumPost.table_name}.created_at DESC"
  
  attr_readonly :forum_posts_count, :forum_threads_count



  # oh has_finder i eagerly await thee
  def self.ordered; find(:all, :order => 'position'); end
  def to_param; permalink; end
  def to_s; name; end

end
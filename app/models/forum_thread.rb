class ForumThread < ActiveRecord::Base
  # include User::Editable

  has_permalink :title, :scope => :forum_id

  before_validation_on_create :set_default_attributes
  validates_presence_of :title

  after_create   :create_initial_post
  before_update  :check_for_moved_forum
  after_update   :set_post_forum_id
  before_destroy :count_user_forum_posts_for_counter_cache
  after_destroy  :update_cached_forum_and_user_counts

  validates_presence_of :user_id, :forum_id, :title
  validates_presence_of :body, :on => :create


  belongs_to :user
  belongs_to :last_user, :class_name => "User"
  belongs_to :forum, :counter_cache => true
  has_many :posts, :class_name => 'ForumPost', :order => "#{ForumPost.table_name}.created_at", :dependent => :delete_all
  has_one  :recent_post, :class_name => 'ForumPost', :order => "#{ForumPost.table_name}.created_at DESC"
  has_many :voices, :through => :posts, :source => :user, :uniq => true


  attr_accessor :body
  attr_accessible :title, :body

  attr_readonly :forum_posts_count, :hits



  def to_s; title; end

  def sticky?; sticky == 1; end
  def hit!; self.class.increment_counter(:hits, id); end
  def paged?; forum_posts_count > ForumPost.per_page; end
  def last_page; [(forum_posts_count.to_f / ForumPost.per_page.to_f).ceil.to_i, 1].max; end

  def update_cached_post_fields(post)
    # these fields are not accessible to mass assignment
    if remaining_post = post.frozen? ? recent_post : post
      self.class.update_all(['last_updated_at = ?, last_user_id = ?, last_forum_post_id = ?, forum_posts_count = ?', 
        remaining_post.created_at, remaining_post.user_id, remaining_post.id, posts.count], ['id = ?', id])
    else
      destroy
    end
  end
  
  def to_param; permalink; end


  def editable_by?(user, is_moderator = nil)
    is_moderator = false#user.moderator_of?(forum) if is_moderator.nil?
    user && (user.id == user_id || is_moderator)
  end

protected

  def create_initial_post
    user.reply self, @body #unless locked?
    @body = nil
  end
  
  def set_default_attributes
    self.sticky          ||= 0
    self.last_updated_at ||= Time.now.utc
  end

  def check_for_moved_forum
    old = ForumThread.find(id)
    @old_forum_id = old.forum_id if old.forum_id != forum_id
    true
  end

  def set_post_forum_id
    return unless @old_forum_id
    posts.update_all :forum_id => forum_id
    Forum.update_all "forum_posts_count = forum_posts_count - #{forum_posts_count}", ['id = ?', @old_forum_id]
    Forum.update_all "forum_posts_count = forum_posts_count + #{forum_posts_count}", ['id = ?', forum_id]
  end
  
  def count_user_forum_posts_for_counter_cache; @user_posts = posts.group_by { |p| p.user_id }; end
  
  def update_cached_forum_and_user_counts
    Forum.update_all "forum_posts_count = forum_posts_count - #{forum_posts_count}", ['id = ?', forum_id]
    @user_posts.each do |user_id, posts|
      User.update_all "forum_posts_count = forum_posts_count - #{posts.size}", ['id = ?', user_id]
    end
  end

end
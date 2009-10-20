require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :display_name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => false
  validates_length_of       :display_name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message


  has_many :posts, :class_name => 'ForumPost', :order => "#{ForumPost.table_name}.created_at desc"
  has_many :threads, :class_name => 'ForumThread', :order => "#{ForumThread.table_name}.created_at desc"

  has_many :role_users
  has_many :roles, :through => :role_users
  
  attr_readonly :forum_posts_count, :last_seen_at
  attr_accessible :login, :email, :display_name, :password, :password_confirmation

  named_scope :named_like, lambda {|name| { :conditions => ["users.display_name like ? or users.login like ?", "#{name}%", "#{name}%"] }}


  def self.prefetch_from(records); find(:all, :select => 'distinct *', :conditions => ['id in (?)', records.collect(&:user_id).uniq]); end
  def self.index_from(records); prefetch_from(records).index_by(&:id); end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def display_name
    n = read_attribute(:display_name)
    n.blank? ? login : n
  end 
  alias_method :to_s, :display_name

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def active?; self.activation_code.nil?; end

  def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    return true if @_list.include?("admin")
    (@_list.include?(role_in_question.to_s) )
  end

  def seen!
    now = Time.now.utc
    self.class.update_all ['last_seen_at = ?', now], ['id = ?', id]
    write_attribute :last_seen_at, now
  end
  
  def to_param; id.to_s; end
  
  def to_xml(options = {})
    options[:except] ||= []
    options[:except] << :email << :login_key << :login_key_expires_at << :password_hash << :openid_url << :activated << :admin
    super
  end

  def post(forum, attributes)
    attributes.symbolize_keys!
    ForumThread.new(attributes) do |thread|
      thread.forum = forum
      thread.user = self
      revise_thread thread, attributes, false#moderator_of?(forum)
    end
  end
 
  def reply(thread, body)
    p "*"*10
    returning thread.posts.build(:body => body) do |post|
      post.forum = thread.forum
      post.user = self
      post.save
    end
  end
  
  def revise(record, attributes)
    is_moderator = false #moderator_of?(record.forum)
    return unless record.editable_by?(self, is_moderator)
    case record
      when ForumThread then revise_thread(record, attributes, is_moderator)
      when ForumPost then post.save
      else raise "Invalid record to revise: #{record.class.name.inspect}"
    end
    record
  end
 
protected

  def revise_thread(thread, attributes, is_moderator)
    thread.title = attributes[:title] if attributes.key?(:title)
    thread.sticky, thread.locked = attributes[:sticky], attributes[:locked] if is_moderator
    thread.save
  end

end
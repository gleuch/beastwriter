class Post < ActiveRecord::Base

  # Associations
  has_many :categories, :through => :category_entry
  has_many :category_entry
  has_many :tags, :through => :tag_entry
  has_many :tag_entry
  has_many :comments
  has_permalink :title

  # Validations
  validates_presence_of :title, :permalink, :content
  validates_uniqueness_of :title, :permalink

  # Named Scopes
  named_scope :active, {
    :conditions => "publish_at <= CURRENT_TIMESTAMP",
    :order => "publish_at DESC"
  }

  named_scope :draft, {
    :conditions => "publish_at => CURRENT_TIMESTAMP",
    :order => "publish_at ASC"
  }

  named_scope :limit, lambda {
    |num| { :limit => num }
  }

  # Over-rides
  def to_param
    permalink
  end

  # Find Methods
  def self.find_by_date(params)
    if params[:month] && params[:year] && params[:day]
      self.find_by_day(params)
    elsif params[:month] && params[:year]
      self.find_by_month(params)
    elsif params[:year]
      self.find_by_year(params)
    end
  end

  def self.find_by_day(params)
    find(:all, :conditions => ["YEAR(publish_at) = ? and MONTH(publish_at) = ? and DAY(publish_at) = ?", params[:year], params[:month], params[:day]])
  end

  def self.find_by_month(params)
    find(:all, :conditions => ["YEAR(publish_at) = ? and MONTH(publish_at) = ?", params[:year], params[:month]])
  end

  def self.find_by_year(params)
    find(:all, :conditions => ["YEAR(publish_at) = ?", params[:year]])
  end

  # Methods

  # Sets the publish_at time to the current UTC time
  def publish_now
    self.publish_at = Time.now.utc
    self.save!
  end

  # Boolean on wether the post is published or not
  def published?
    if self.publish_at < Time.now.utc
      true
    else
      false
    end
  end

end

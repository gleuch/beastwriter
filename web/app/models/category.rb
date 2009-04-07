class Category < ActiveRecord::Base

  # Associations
  acts_as_tree :order => "name"
  has_permalink :name
  has_many :category_entry
  has_many :posts, :through => :category_entry

  # Validations
  validates_presence_of :name, :permalink, :description
  validates_uniqueness_of :name, :permalink

  named_scope :root, :conditions => { :parent_id => 0 }

  # Over-rides
  def to_param
    permalink
  end

end

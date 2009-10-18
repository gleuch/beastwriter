# == Schema Information
# Schema version: 20090404170416
#
# Table name: categories
#
#  id          :integer         not null, primary key
#  parent_id   :integer         default(0)
#  name        :string(50)
#  permalink   :string(50)
#  description :string(300)
#  created_at  :datetime
#  updated_at  :datetime
#

class Category < ActiveRecord::Base

  # Associations
  acts_as_tree :order => "name"
  has_permalink :name
  has_many :category_entry
  has_many :entries, :through => :category_entry

  # Validations
  validates_presence_of :name, :permalink, :description
  validates_uniqueness_of :name, :permalink

  named_scope :root, :conditions => { :parent_id => 0 }

  # Over-rides
  def to_param
    permalink
  end

end

# == Schema Information
# Schema version: 20090422233019
#
# Table name: links
#
#  id         :integer         not null, primary key
#  name       :string(50)
#  url        :string(100)
#  deleted_at :datetime
#  created_at :datetime
#  updated_at :datetime
#

class Link < ActiveRecord::Base

  validates_presence_of :name, :url
  validates_uniqueness_of :name, :url

end

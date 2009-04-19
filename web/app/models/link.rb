class Link < ActiveRecord::Base

  validates_presence_of :name, :url
  validates_uniqueness_of :name, :url

end

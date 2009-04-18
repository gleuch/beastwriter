# == Schema Information
# Schema version: 20090404170416
#
# Table name: comments
#
#  id         :integer         not null, primary key
#  post_id    :integer
#  alias      :string(255)
#  ip         :string(255)
#  website    :string(255)
#  email      :string(255)
#  comment    :string(255)
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#

class Comment < ActiveRecord::Base

  belongs_to :post

  named_scope :active, :conditions => [ "deleted_at IS NULL" ]
  named_scope :order, :order => "created_at DESC"

end

# == Schema Information
# Schema version: 20090422233019
#
# Table name: comments
#
#  id           :integer         not null, primary key
#  entry_id      :integer
#  author       :string(255)
#  user_ip      :string(255)
#  author_url   :string(255)
#  author_email :string(255)
#  content      :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  deleted_at   :datetime
#  user_agent   :string(500)
#

class Comment < ActiveRecord::Base

  has_rakismet :user_ip => :user_ip
  belongs_to :entry

  named_scope :active, :conditions => [ "deleted_at IS NULL" ]
  named_scope :order, :order => "created_at DESC"

end

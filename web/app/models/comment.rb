class Comment < ActiveRecord::Base

  belongs_to :post

  named_scope :active, :conditions => [ "deleted_at IS NULL" ]
  named_scope :order, :order => "created_at DESC"

end

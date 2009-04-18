# == Schema Information
# Schema version: 20090404170416
#
# Table name: tag_entries
#
#  id         :integer         not null, primary key
#  post_id    :integer
#  tag_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class TagEntry < ActiveRecord::Base

  belongs_to :post
  belongs_to :tag

end

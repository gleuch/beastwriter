# == Schema Information
# Schema version: 20090404170416
#
# Table name: category_entries
#
#  id          :integer         not null, primary key
#  post_id     :integer
#  category_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class CategoryEntry < ActiveRecord::Base

  belongs_to :post
  belongs_to :category

end

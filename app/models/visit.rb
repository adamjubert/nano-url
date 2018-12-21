# == Schema Information
#
# Table name: visits
#
#  id         :bigint(8)        not null, primary key
#  link_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Visit < ApplicationRecord
  belongs_to :link

  validates :link_id, presence: true 
end

# == Schema Information
#
# Table name: links
#
#  id         :bigint(8)        not null, primary key
#  long_link  :string           not null
#  short_link :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Link, type: :model do
  describe '#generate_short_link' do
    it 'creates a short_link with Base36 encoding' do
      link = Link.create(long_link: 'test.com')

      expect(link.short_link).to eq(link.id.to_s(36))
    end
  end
end

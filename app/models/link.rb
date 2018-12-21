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

class Link < ApplicationRecord
  has_many :visits

  validates :long_link, presence: true

  before_create :strip_whitespace
  after_create :generate_short_link, :fetch_title

  def self.top_links(num)
    count_visits_sql = Arel.sql('count(visits.id) desc')

    Link.joins(:visits)
        .group('links.id')
        .order(count_visits_sql)
        .limit(num)
  end

  def create_visit!
    visits.create(link_id: id)
  end

  def http_link
    return long_link if starts_with_http_or_https?

    "http://#{long_link}"
  end


  private

  def strip_whitespace
    self.long_link = long_link.strip
  end

  # Utilizes Base36 Encoding: https://en.wikipedia.org/wiki/Base36
  def generate_short_link
    self.short_link = id.to_s(36)
    save!
  end

  def fetch_title
    FetchTitleJob.perform_now(self)
  end

  def starts_with_http_or_https?
    ['http://', 'https://'].any? { |h| long_link.start_with?(h) }
  end
end

class Link < ApplicationRecord
  has_many :visits

  validates :long_link, presence: true

  after_create :generate_short_link, :fetch_title

  def create_visit!
    visits.create(link_id: id)
  end

  def http_link
    return long_link if starts_with_http_or_https?

    "http://#{long_link}"
  end

  private

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

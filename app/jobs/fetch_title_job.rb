class FetchTitleJob < ApplicationJob
  queue_as :default

  def perform(link)
    http_link = link.http_link
    response  = HTTParty.get(http_link)
    document  = Nokogiri::HTML(response.body)
    title     = document.at('title').text

    link.update_attributes(title: title)
  rescue => error
    puts "Error fetching title for #{link.inspect}. Details: #{error}"
  end
end

class FetchTitleJob < ApplicationJob
  queue_as :default

  def perform(link)
    http_link = link.http_link
    response  = HTTParty.get(http_link)
    document  = Nokogiri::HTML(response.body)
    title     = document.at('title').text

    link.update_attributes(title: title)
  rescue SocketError => error
    puts "Invalid long_link '#{http_link}' for Link id '#{link.id}'. Details: #{error}"
  end
end

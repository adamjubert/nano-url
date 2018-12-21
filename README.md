# README

## Terminal Commands

### GET /top
View the top 100 most frequently visited links
`curl localhost:3000/top.json`

Response
`[{"long_link":"google.com","short_link":"11","title":"Google"},{"long_link":"google.co.uk","short_link":"19","title":"Google"}]`

### GET /links/:short_link
View the link at this url
`curl localhost:3000/links/1a`

200 Response
`{"long_link":"cnn.com","short_link":"1a"}`

404 Response
`{"errors":"Invalid URL"}`

### POST /links
Create a new short url for "github.com"
`curl -d "link[long_link]=github.com" localhost:3000/links`

200 Response
`{"long_link":"github.com","short_link":"1a"}`

Error Response
`{"errors":"[List of errors]"}`


## Implementation
### Algorithm
Links are [Base36 encoded](https://en.wikipedia.org/wiki/Base36) based on their IDs, ensuring the shortest possible link containing lowercase alphanumeric characters:
```
class Link < ApplicationRecord
  after_create :generate_short_link

  def generate_short_link
    self.short_link = id.to_s(36)
    save!
  end
end
```

### Fetching Titles
I utilized ActiveJob and Sidekiq to perform the job, HTTParty to fetch the HTML, and Nokogiri to find the <title> tag.

```
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
```

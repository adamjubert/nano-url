# README

## Setup
```
$ https://github.com/adamjubert/nano-url.git
$ cd nano-url/
$ bundle install
$ bundle exec rake db:create db:migrate
$ rails s
```

If you would like to seed the database with 150 URLs from the Moz Top 500, you can run `bundle exec rake db:seed`. This will take a couple of minutes.

You can then open a new terminal window and run any of the following terminal commands.

## Terminal Commands

### GET /top
View the top 100 most frequently visited links

```$ curl localhost:3000/top.json```

Response

```[{"long_link":"google.com","short_link":"11","title":"Google"},{"long_link":"google.co.uk","short_link":"19","title":"Google"}, ...]```

### GET /links/:short_link
View the link at a specific short url (for example, 1a)

```$ curl localhost:3000/links/1a```

200 Response

```{"long_link":"cnn.com","short_link":"1a"}```

404 Response

```{"errors":"Invalid URL"}```

Visiting the short URL in your browser window will redirect you to the long URL.
```http://localhost:3000/links/1e => http://cnn.com```

### POST /links
Create a new short url for "github.co.uk"

```$ curl -d "link[long_link]=github.co.uk" localhost:3000/links```

200 Response

```{"long_link":"github.com","short_link":"1a"}```

Error Response

```{"errors":"[List of errors]"}```


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

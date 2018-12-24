unless Link.first.present?
  total_links = 149
  file        = File.open('./spec/data/moz_top_500.csv')
  long_links  = CSV.parse(file).flatten[0..total_links]

  file.close

  long_links.each.with_index do |long_link, index|
    link         = Link.create(long_link: long_link)
    visits_count = rand(0..5)

    visits_count.times { link.visits.create }

    puts "[#{index + 1}/#{total_links + 1}] Created short link '#{link.short_link}' for '#{link.long_link}' with #{visits_count} visits."
  end
end

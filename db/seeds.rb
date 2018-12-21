unless Link.first.present?
  file       = File.open('./spec/data/moz_top_500.csv')
  long_links = CSV.parse(file).flatten[0..150]

  file.close

  long_links.each do |long_link|
    link         = Link.create(long_link: long_link)
    visits_count = rand(1..5)

    visits_count.times { link.visits.create }

    puts "Created #{link.inspect} and #{visits_count} visits."
  end
end

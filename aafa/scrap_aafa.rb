require 'open-uri'
require 'nokogiri'
require "uri"
require 'json'

cpt = 1
actors = []
91.times do #91
  #url = "https://aafa-asso.info/membres/?page_7066b=#{cpt}"
  puts "#{cpt} / 91 ..."
  html_file = File.read("html/page#{cpt}.html") #URI.open(url).read
  html_doc = Nokogiri::HTML(html_file)
  html_doc.search('.um-member').each do |element|
    name = element.search('.um-member-name').text.strip
    email = element.search('.um-member-metaline-user_email') ? element.search('.um-member-metaline-user_email').text.strip.gsub("Adresse e-mail: ","") : ""
    actor = {name: name, email:email}
    actors << actor
  end
  cpt += 1
end

# write CSV
File.open("actors.json", 'wb') do |file|
  file.write(JSON.pretty_generate(actors))
end

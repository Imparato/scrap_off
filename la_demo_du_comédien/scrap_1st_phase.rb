require 'open-uri'
require 'nokogiri'
require "uri"
require 'json'

cpt = 1
actors = []
43.times do
  url = "https://www.lademoducomedien.com/?pa=&rg=&s=a&a=&agc=&agt=&search=&o=noma&n=72&p=#{cpt}"
  puts "#{cpt} / 43 ..."
  cpt += 1
  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML(html_file)
  html_doc.search('.demobox').each do |element|
    img = element.search('img')
    name = img.attribute('alt').value
    url = "https://www.lademoducomedien.com/"+element.attribute('href').value
    actor = {name: name, url:url}
    actors << actor
  end
end

# write CSV
File.open("actors.json", 'wb') do |file|
  file.write(JSON.pretty_generate(actors))
end

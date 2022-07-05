require 'json'
require 'pry-byebug'
require 'open-uri'
require 'nokogiri'
require 'csv'

# this script needs file 'off_parse.json' to be ready
# see scrapper_off2021 to buil the file

filepath = 'off_parse2022.json'
serialized_plays = File.read(filepath)

places = {}

def scrap_theatre(url)
  res = {}
  url = "https://www.festivaloffavignon.com#{url}"
  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML(html_file)
  res[:image_url] = html_doc.search('.img-responsive').first.attribute('src').value
  res[:address] = html_doc.search('.text-muted').first.text.strip.gsub("\n","").gsub("\r","").gsub(/ *- */," ").gsub(/avignon.*/i,"Avignon")
  if res[:address].match(/(\d{5})/)
    cp = res[:address].match(/(\d{5})/)[1]
    res[:address] = res[:address].gsub(cp, " #{cp}")
  # else
    # binding.pry
  end
  # binding.pry
  res[:longlat] = html_doc.search('.btn-info').first.attribute('href').value.match(/q=(.+)/)[1].gsub("+", " ")
  res[:tel] = html_doc.search('.tel-btn').map{|tel| tel.text.strip}
  res[:social] = html_doc.search('.btn-social').map{|tel| tel.attribute('href').value}
  return res
end

plays = JSON.parse(serialized_plays)
plays.each do |play|
  places[play["place_url"]] = {name: play["place"]}
end
max = places.keys.count

puts "#{max} théâtre found !"
counter = 1

places.keys.each do |url|
  puts "#{counter} / #{max}"
  theatre = scrap_theatre(url)
  places[url][:image_url] = theatre[:image_url]
  places[url][:address] = theatre[:address]
  places[url][:longlat] = theatre[:longlat]
  places[url][:tel] = theatre[:tel]
  places[url][:social] = theatre[:social]
  places[url][:anchor] = url
  counter += 1
end

File.open("theatre_list.json", 'wb') do |file|
  file.write(JSON.pretty_generate(places))
end

# csv generator
blog_root_url = "https://www.imparato.io/blog/tous-les-spectacles-du-off-2022-aujourd-hui-theatre-par-theatre"
csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
CSV.open("theatres.csv", 'wb', col_sep: ',', force_quotes: true, quote_char: '"' ) do |csv|
  csv << ['Nom', 'Adresse', 'longlat', "Voir les spectacles du jour"]
  places.values.each do |value|
    csv << [value[:name], value[:address], value[:longlat], blog_root_url+'#'+value[:anchor]] if value[:longlat]
  end
  # ...
end

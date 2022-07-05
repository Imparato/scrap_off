require 'open-uri'
require 'nokogiri'
require 'json'
require_relative 'lib/play'

plays = []
page = 1
counter = 1
MAX = 1656

# le 12 de 10h à 11h
# https://www.festivaloffavignon.com/programme/2021/0,0,0,0,0,0,99,99,12,12,10,11,4,100,0/

loop do
  url = "https://www.festivaloffavignon.com/programme/2022/0,0,0,0,0,0,99,99,0,0,0,0,2,100,0/page#{page}/"
  puts "Page #{page}"
  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML(html_file)

  html_doc.search('.listing-item').each do |element|
    puts "#{counter} / #{MAX}"
    att = {}
    att[:title] = element.search('.titre-spectacle').text.strip
    att[:infos] = element.search('.text-muted').map{|part| part.text.gsub("\n","").gsub("\r","").strip}.select{|part| !part.empty?}
    att[:image_url] = element.search('.img-responsive').attribute('src').value
    att[:page_url] = element.search('.titre-spectacle').attribute('href').value
    att[:place] = element.search('.btn-simple').text.strip
    att[:place_url] = element.search('.btn-simple').attribute('href').value
    att[:badges] = element.search('.badge-dark').map {|badge| badge.text.strip}
    # play = Play.new(att)
    plays.push(att)
    counter += 1
    break if counter > MAX
  end
  break if counter > MAX
  page += 1
end

File.open("off_parse2022.json", 'wb') do |file|
  file.write(JSON.pretty_generate(plays))
end

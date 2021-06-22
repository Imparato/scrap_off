require 'open-uri'
require 'nokogiri'
require_relative 'play'

plays = []

1.times do |page|
  url = "https://www.festivaloffavignon.com/programme/2021/0,0,0,6,0,0,99,99,0,0,0,0,2,100,0/page#{page + 1}/"

  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML(html_file)

  html_doc.search('.listing-item').first(2).each do |element|
    att = {}
    att[:title] = element.search('.titre-spectacle').text.strip
    att[:infos] = element.search('.text-muted').map{|part| part.text.strip}.select{|part| !part.empty?}
    att[:image_url] = element.search('.img-responsive').text.strip
    att[:page_url] = element.search('.titre-spectacle').attribute('href').value
    att[:place] = element.search('.btn-simple').text.strip
    att[:place_url] = element.search('.btn-simple').attribute('href').value
    att[:badges] = element.search('.badge-dark').map {|badge| badge.text.strip}
    play = Play.new(att)
    p play
  end
end

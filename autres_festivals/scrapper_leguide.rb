require 'open-uri'
require 'nokogiri'
require 'json'
require 'pry-byebug'

MAX = 771

def search_page(link)
  url = "http://leguidedesfestivals.com/#{link}"
  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML(html_file)
  text = html_doc.search('.tab-pane').text.strip
  text = text.split("\n").map(&:strip).join(" ")
  text = text.gsub("Cinéma   Théâtres   Danses","")
  theatre = text.match?(/théâtre/i)
  begin
    url = html_doc.search('strong a').find{|u| !u.attribute('href').value.include?("leguidedesfestivals") }.attribute('href').value
  rescue Exception
    url = ""
  end
  return theatre, url
end

# le 12 de 10h à 11h
# http://leguidedesfestivals.com/index.php5?page=festivals-saison-ete&p=31
# 31 pages max


def main
  festivals = []
  page = 1
  counter = 1
  loop do
    url = "http://leguidedesfestivals.com/index.php5?page=festivals-saison-ete&p=#{page}/"
    puts "Page #{page}"
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML(html_file)

    html_doc.search('.list-group-item').each do |element|
      img = element.search('img')
      next if img.empty?
      puts "#{counter} / #{MAX}"
      att = {}

      att[:title] = img.attribute('alt').value
      att[:image_url] = img.attribute('src').value
      h6 = element.next_element.next_element.next_element
      att[:dates] = h6.text.strip
      att[:place] = h6.next_sibling.next_sibling.text.strip
      att[:page_url] = element.attribute('href').value
      search = search_page(att[:page_url])
      att[:theatre] = search[0]
      att[:target_url] = search[1]

      # play = Play.new(att)
      festivals.push(att)
      counter += 1
      break if counter > MAX
    end
    break if counter > MAX
    page += 1
  end

  File.open("festivals2021.json", 'wb') do |file|
    file.write(JSON.pretty_generate(festivals))
  end
end
main
# p search_theatre?("2021-festival-inventio-39915.html")

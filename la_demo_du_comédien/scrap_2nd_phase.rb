require 'open-uri'
require 'nokogiri'
require "uri"
require 'json'


# read json
actors = JSON.parse(File.read('actors.json'))

actors.each_with_index do |actor, index|
  if actor["email"].nil?
    url = actor["url"]
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML(html_file)
    puts "#{index} / #{actors.length} ..."
    html_doc.search('p').each do |element|
      actor["email"] = ""
      if element.text.strip.include?("E-mail")
        actor["email"] = element.search('a').text.strip
        break
      end
    end
    # write file
    File.open("actors.json", 'wb') do |file|
      file.write(JSON.pretty_generate(actors))
    end
  end
end

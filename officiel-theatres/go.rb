require "open-uri"
require "nokogiri"
require "json"

id = 1
result = []
15.times do
  url = "https://www.offi.fr/theatre/programme.html?npage=#{id}&valuesSortGroup=lieu&tri=asc"
  puts id
  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML(html_file)
  # text = html_doc.text.strip

  html_doc.search('.filtred-by-map').each do |element|
    name = element.search('.h2-26').text.strip
    url = element.search('.h2-26').attribute('href').value
    address = element.text.strip
    address = address.gsub(/[\t\n]/,"")
    address = address.gsub("  "," ")
    address = address.gsub("  "," ")
    address = address.gsub(/ (\d+e)? *Plan/,"")

    address = address[name.length..-1]
   result << {name: name, address: address, url: url}
  end
  id += 1

end

File.open("theatres.json", "wb") do |file|
  file.write(JSON.pretty_generate(result))
end

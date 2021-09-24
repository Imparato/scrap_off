require 'open-uri'
require 'nokogiri'
require "uri"


DOUBLE_ESCAPED_EXPR = /%25([0-9a-f]{2})/i

def escape_uri(uri)
  URI.encode(uri).gsub(DOUBLE_ESCAPED_EXPR, '%\1')
end

url = "https://assorda.com/membres/"

html_file = URI.open(url).read
html_doc = Nokogiri::HTML(html_file)
members = []
html_doc.search('.h6 a').each do |element|
  str = ""
  element.traverse { |n| str << n.to_s if (n.name == "text" or n.name == "br") }
  str.gsub!("<br>"," ")
  member = {name: str, page: "https://assorda.com/"+element.attribute('href').value}
  escape_uri = escape_uri(member[:page])
  p escape_uri
  html_subdoc = Nokogiri::HTML(URI.open(escape_uri).read)
  email = html_subdoc.xpath("//a[contains(@href, 'mailto')]")&.text.strip
  member[:email] = email
  members << member
end

# write CSV
require 'csv'

csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
filepath    = 'members.csv'

CSV.open(filepath, 'wb', csv_options) do |csv|
  csv << ['email', 'name']
  members.each do |member|
    csv << [member[:email], member[:name]] unless member[:email].empty?
  end
end

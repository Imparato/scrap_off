require "open-uri"
require "nokogiri"


url = "https://en.wikipedia.org/wiki/2022_United_States_House_of_Representatives_elections"

html_file = URI.open(url).read
html_doc = Nokogiri::HTML(html_file)
text = html_doc.text.strip

text = text.gsub(/[\n\.\?,;!]/," ")
words = text.downcase.split(" ")
count = {}
words.each do |word|
  count[word] = 0 unless count[word]
  count[word] += 1
end
words = count.sort_by{|k,v| -v}.to_h.keys.first(30)
p words

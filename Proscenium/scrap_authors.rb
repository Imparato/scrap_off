require 'uri'
require 'net/http'
require 'openssl'
require 'csv'


def scrap(id)
  url = URI("https://api.webscrapingapi.com/v1?api_key=giqX5sFNF0skni3rBPZ6Po0ritd0bwLM&url=https%3A%2F%2Fwww.leproscenium.com%2FPresentationAuteur.php%3FIdAuteur%3D#{id}&method=GET&device=desktop&proxy_type=datacenter&keep_headers=1")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)

  response = http.request(request)
  return response.read_body
end

def extract_email(text)
  email = text.match(/mailto:([^>\n]+)/)
  return email[1] if email
  return ""
end

def extract_web_site(text)
  site = text.match(/Son site : <\/b><a href=([^ \n]+)/)
  return site[1] if site
  return ""
end

csv_options = { col_sep: ',', headers: :first_row }
filepath    = 'auteurs_scores.csv'
authors = []
CSV.foreach(filepath, csv_options) do |row|
  authors << [row["Author"], row["author_id"].to_i, row["SUM de Created"], row["SUM de Played"]]
end

authors.first(150).each_with_index do |author, index|
  puts "#{index} / #{authors.length}"
  text = scrap(author[1])
  author << extract_email(text)
  author << extract_web_site(text)
end

require 'csv'

csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
filepath    = 'auteurs_score_full.csv'

CSV.open(filepath, 'wb', csv_options) do |csv|
  authors.each do |author|
    csv << author
  end
end

#text = scrap(1805)
#puts extract_email(text)
#puts extract_web_site(text)

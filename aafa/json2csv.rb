require 'open-uri'
require 'nokogiri'
require "uri"
require 'json'
require 'csv'


# read json
actors = JSON.parse(File.read('actors.json')).select{|actor| !actor["email"].empty?}

csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
filepath    = 'actors.csv'

CSV.open(filepath, 'wb', csv_options) do |csv|
  csv << ['email', 'name']
  actors.each do |actor|
    csv << [actor["email"], actor["name"]]
  end
end

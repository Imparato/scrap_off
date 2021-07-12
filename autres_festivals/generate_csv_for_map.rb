# require "cloudinary"
require_relative "festivals"
require 'pry-byebug'
require 'dotenv/load'
require 'csv'


fests = festivals
count = 1

csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
filepath    = 'festivals.csv'

CSV.open(filepath, 'wb', csv_options) do |csv|
  csv << ['city', 'name', 'url']
  fests.each do |festival|
    csv << [festival.place_for_csv, festival.title, "https://www.imparato.io/blog/l_ete_des_festivals_de_theatre_2021##{festival.slug}"]
  end
end

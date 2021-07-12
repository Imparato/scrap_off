require 'json'
require_relative '../lib/festival'
require 'dotenv/load'

def timing(dates)
  months = %w(Juillet Aout Septembre)
  months.each {|month| return true if dates.include?(month)}
  return false
end

def festivals
  months = %w(Juillet Aout Septembre)
  JSON.parse(File.read('festivals2021.json')).map{|part| Festival.new(part)}.select{|p| p.theatre && timing(p.dates)}
end

p festivals.count

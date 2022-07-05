require 'json'
require 'pry-byebug'
require 'erb'
require 'date'

# this script needs file 'off_parse.json' to be ready
# see scrapper_off2021 to buil the file

require_relative 'lib/play'

def date_of_the_day(date)
  week_days = %w(lundi mardi mercredi jeudi vendredi samedi dimanche)
  "#{week_days[date.wday - 1].capitalize} #{date.day} juillet 2022"
end

pubs = File.read("pubs.txt").split("\n")

plays = JSON.parse(File.read('off_parse2022.json')).map{|part| Play.new(part)}.select{|p| p.valid?}
theatres = JSON.parse(File.read('theatre_list.json')).sort_by{|_key, value| value["name"]}.to_h
# binding.pry
main_template = ERB.new(File.read('md_theatre_template.erb'))

for day in (7..30)
  # today File
  date = Date.new(2022, 7, day)
  selection = plays.select{|p| p.schedule(day)}
  # binding.pry if day == 13
  # binding.pry
  # puts "#{day} : #{plays.count{|play| !play.schedule(day).nil?}}"
  md_file = "theatres/#{day}.md"
  File.open(md_file, 'wb') do |file|
    file.write(main_template.result)
  end



end

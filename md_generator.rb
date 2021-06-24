require 'json'
require 'pry-byebug'
require 'erb'
require 'date'

# this script needs file 'off_parse.json' to be ready
# see scrapper_off2021 to buil the file

require_relative 'lib/play'

def date_of_the_day(date)
  week_days = %w(lundi mardi mercredi jeudi vendredi samedi dimanche)
  "#{week_days[date.wday - 1].capitalize} #{date.day} juillet 2021"
end

filepath = 'off_parse.json'
serialized_plays = File.read(filepath)

plays = JSON.parse(serialized_plays).map{|part| Play.new(part)}.select{|p| p.valid?}
# binding.pry
main_template = ERB.new(File.read('md_template.erb'))
div_template = ERB.new(File.read('div_template.erb'))

for day in (7..31)
  # today File
  date = Date.new(2021, 7, day)
  time = "aujourd'hui"
  selection = plays.select{|p| p.schedule(day)}
  # binding.pry
  # puts "#{day} : #{plays.count{|play| !play.schedule(day).nil?}}"
  md_file = "today/#{day}.md"
  File.open(md_file, 'wb') do |file|
    file.write(main_template.result)
  end

  # tomorrow file
  time = "demain"
  md_file = "tomorrow/#{day}.md"
  File.open(md_file, 'wb') do |file|
    file.write(main_template.result)
  end


end

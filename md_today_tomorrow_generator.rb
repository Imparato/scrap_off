require 'json'
require 'pry-byebug'
require 'erb'
require 'date'

# this script needs file 'off_parse.json' to be ready
# see scrapper_off2021 to buil the file

require_relative 'lib/play'

slugs = {
  today: "quelle-piece-voir-aujourd-hui-au-festival-off-d-avignon",
  tomorrow: "quelle-piece-voir-demain-au-festival-off-d-avignon",
  theatres: "tous-les-spectacles-du-off-2022-aujourd-hui-theatre-par-theatre"
}

def date_of_the_day(date)
  week_days = %w(lundi mardi mercredi jeudi vendredi samedi dimanche)
  "#{week_days[date.wday - 1].capitalize} #{date.day} juillet 2021"
end

pubs = File.read("pubs.txt").split("\n")

plays = JSON.parse(File.read('off_parse2022.json')).map{|part| Play.new(part)}.select{|p| p.valid?}
# binding.pry
main_template = ERB.new(File.read('md_today_tomorrow_template.erb'))
div_template = ERB.new(File.read('div_template.erb'))

for day in (7..30)
  # today File
  date = Date.new(2022, 7, day)
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

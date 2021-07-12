require 'CSV'

plays = JSON.parse(File.read('off_parse.json')).map{|part| Play.new(part)}.select{|p| p.valid?}


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

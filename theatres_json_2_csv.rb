require "json"
require "csv"
require "pry-byebug"

filepath = "theatre_list.json"
serialized_theatres = File.read(filepath)
theatres = JSON.parse(serialized_theatres)


# CSV.open("off2022.csv", "wb", force_quotes: true) do |csv|
#   csv << ["nom", "adresse", "cp", "ville"]
#   theatres.each do |key, theatre|
#     name = theatre["name"]
#     if name
#       match = name.match(/([^\(\n]+)(\((.+)\))?( ([^\n]+))?/)
#       # binding.pry
#       name = "#{match[3]} #{match[1]} #{match[5]}".strip if match[3]
#       p name
#       match = theatre["address"].match(/^(.+) (\d{5}) (.+)$/)
#       address = match[1]
#       cp = match[2]
#       city = match[3]
#       csv << [name, address, cp, city]
#     end
#   end
# end


CSV.open("off2022_email.csv", "wb", force_quotes: true) do |csv|
  csv << ["email"]
  theatres.each do |key, theatre|
    social = theatre["social"]
    if social
      email = social.find{|line| line.include?'mailto:'}
      if email
        email=email[7..100]
        csv << [email]
      end
    end
  end
end

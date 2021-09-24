require 'uri'
require 'net/http'
require 'openssl'


91.times do |cpt|
  puts "#{cpt+1} / 91"
  url = URI("https://api.webscrapingapi.com/v1?api_key=giqX5sFNF0skni3rBPZ6Po0ritd0bwLM&url=https%3A%2F%2Faafa-asso.info%2Fmembres%2F%3Fpage_7066b%3D#{cpt+1}&method=GET&device=desktop&proxy_type=datacenter&render_js=1&wait_until=domcontentloaded&keep_headers=1&wait_for=3&country=fr")


  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)

  response = http.request(request)
  puts response.read_body

  File.open("html/page#{cpt+1}.html", 'wb') do |file|
    file.write(response.read_body)
  end

end

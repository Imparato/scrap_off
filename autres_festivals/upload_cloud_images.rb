require "cloudinary"
require_relative "festivals"
require 'pry-byebug'
require 'dotenv/load'


Cloudinary.config do |config|
      config.cloud_name =  ENV['CLOUDINARY_CLOUD_NAME']
      config.api_key = ENV['CLOUDINARY_API_KEY']
      config.api_secret = ENV['CLOUDINARY_API_SECRET']
end

fests = festivals
count = 1
fests.each do |festival|
  p "#{count} / #{fests.size}"
  count += 1
  begin
    Cloudinary::Uploader.upload(festival.image_url, public_id: festival.public_id)
  rescue Exception => e
    binding.pry
  end

end

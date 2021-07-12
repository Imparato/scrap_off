require 'erb'
require 'date'
require_relative "festivals"

fests = festivals
count = 1

main_template = ERB.new(File.read('article.erb'))

md_file = "article.md"
File.open(md_file, 'wb') do |file|
  file.write(main_template.result)
end

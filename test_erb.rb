# Book     = Struct.new(:title, :author)
require 'erb'
coucou = "haha"
template = ERB.new(File.read('test.erb'))
p template.result()

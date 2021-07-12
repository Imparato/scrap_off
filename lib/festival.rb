class Festival
  attr_reader :title, :image_url, :dates, :place, :page_url, :theatre, :target_url
  def initialize(attributes)
    attributes.transform_keys!(&:to_sym)
    @title = attributes[:title].strip.gsub(" ","")
    @image_url = "http://leguidedesfestivals.com/"+attributes[:image_url]
    @dates = attributes[:dates].strip.gsub(" ","")
    @place = attributes[:place].strip
    @page_url = attributes[:page_url]
    @theatre = attributes[:theatre]
    @target_url = attributes[:target_url]
  end

  def place_for_csv
    @place.split(" - ").first.strip.gsub(" ","").capitalize+", France"
  end

  def public_id
    "blog/festi2021/"+@image_url.split("/").last.split(".").first
  end

  def slug
    @title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def zeego_url
    "https://res.cloudinary.com/zeegomatic-io/image/upload/blog/festi2021/#{@image_url.split("/").last.split(".").first}.jpg"
  end

end

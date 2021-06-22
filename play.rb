class Play
  attr_reader :title, :image_url
  def initialize(attributes)
    @keep = attributes
    @title = attributes[:title]
    @place = attributes[:place]
    @place_url = attributes[:place_url]
    @infos = attributes[:infos]
    @image_url = attributes[:image_url]
    @page_url = attributes[:page_url]
    @badges = attributes[:badges]
  end

  def place
    matches = @place.match(/^([^\(]+)( \((.+)\))?$/
    return "#{matches[3]} #{matches[1]}" if matches[3]
    @place
  end

  def

  def to_h
    @keep
  end

end

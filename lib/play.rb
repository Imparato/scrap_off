require_relative "schedule"
class Play
  attr_reader :title, :image_url, :place_url, :badges, :page_url, :schedules
  def initialize(attributes)
    attributes.transform_keys!(&:to_sym)
    @keep = attributes
    @title = attributes[:title]
    @place = attributes[:place]
    @place_url = attributes[:place_url]
    @image_url = attributes[:image_url]
    @page_url = "https://www.festivaloffavignon.com"+attributes[:page_url]
    @badges = attributes[:badges]
    @schedules = attributes[:infos].map{|info| Schedule.new(info)}
  end

  def place
    matches = @place.match(/^([^\(]+)( \((.+)\))?$/)
    place = @place
    place =  "#{matches[3]} #{matches[1]}" if matches && matches[3]
    place.split.map(&:capitalize)*' '
  end

  def to_h
    @keep
  end

  def schedule(day)
    @schedules.find{|s| s.today?(day)}
  end

  def valid?
    @schedules.count{|s| s.valid} == @schedules.count
  end

  def relache_tomorrow?(day)
    @schedules.select{|s| s.relache_tomorrow?(day)}.count == @schedules.count
  end

end

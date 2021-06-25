class Schedule
  attr_reader :days, :time, :duration, :valid
  def initialize(litteral)
    @valid = true
    litteral.gsub!("\u00A0"," ")
    matches = litteral.match(/(?<nil1>du (?<start>\d+) au (?<stop>\d+)|les? (?<dates>[^-]+)) juillet(?<nil3>.*jours.(?<pairs>pairs|impairs))?(?<nil2> - .elâche.? (?<nila>les?|:) (?<relache>.+) juillet)? *(?<nilx>à|de) *(?<horaire>\d+h\d*).+: (?<duree>.+)/)
    unless matches
      @valid = false
    else
      start = matches[:start]
      stop = matches[:stop]
      dates = matches[:dates]
      pairs = matches[:pairs]
      relache = nil
      relache = matches[:relache].gsub(" et ",",") if matches[:relache]
      @time = matches[:horaire]
      @duration = matches[:duree]
      @days = []
      # date du spectacles
      if start && stop
        @days = (start.to_i..stop.to_i).to_a
      elsif dates
        @days = dates.split(",").map{|day| day.to_i}
      end

      # jours pairs/impairs
      if pairs
        @days.select!{|day| pairs == "pairs" ? day.even? : day.odd?}
      end

      # jours de relache
      if relache
        relache = relache.split(",").map{|day| day.to_i}
        @days.reject!{|day| relache.include? day}
      end
    end
  end

  def today?(date)
    @days.include?(date)
  end

  def today_with_time?(today, hour_start, hour_stop)
    today?(today) && on_time?(hour_start, hour_stop)
  end

  def relache_tomorrow?(today)
    return !today?(today + 1)
  end

  def time_to_i
    @time.gsub("h","").strip.to_i
  end

  private

  def on_time?(hour_start, hour_stop)
    time_start = @time.split("h").first.to_i
    (time_start >= hour_start) && (time_start < hour_stop)
  end

end

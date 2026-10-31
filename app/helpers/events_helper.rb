module EventsHelper
  SPANISH_MONTHS = {
    1 => "Enero", 2 => "Febrero", 3 => "Marzo", 4 => "Abril",
    5 => "Mayo", 6 => "Junio", 7 => "Julio", 8 => "Agosto",
    9 => "Septiembre", 10 => "Octubre", 11 => "Noviembre", 12 => "Diciembre"
  }.freeze

  SPANISH_DAYS = {
    0 => "Domingo", 1 => "Lunes", 2 => "Martes", 3 => "Miércoles",
    4 => "Jueves", 5 => "Viernes", 6 => "Sábado"
  }.freeze

  def format_event_date(datetime)
    return "Fecha por definir" if datetime.blank?

    if I18n.locale == :es
      day_name = SPANISH_DAYS[datetime.wday]
      month_name = SPANISH_MONTHS[datetime.month]
      "#{day_name}, #{datetime.day} de #{month_name} de #{datetime.year}"
    else
      datetime.strftime("%A, %B %d, %Y")
    end
  end

  def format_event_time(datetime)
    return "" if datetime.blank?
    datetime.strftime("%I:%M %p")
  end

  def format_event_duration(minutes)
    return "Duración flexible" if minutes.blank?

    mins = minutes.to_i
    if mins < 60
      "#{mins} min"
    elsif mins % 60 == 0
      hours = mins / 60
      label = I18n.locale == :es ? (hours == 1 ? "hora" : "horas") : (hours == 1 ? "hour" : "hours")
      "#{hours} #{label} (#{mins} min)"
    else
      hours = mins / 60
      rem_mins = mins % 60
      "#{hours}h #{rem_mins}m (#{mins} min)"
    end
  end

  def google_maps_url(event)
    target = event.address.presence || (event.geocoded? ? "#{event.latitude},#{event.longitude}" : "")
    "https://www.google.com/maps/search/?api=1&query=#{ERB::Util.url_encode(target)}"
  end

  def apple_maps_url(event)
    name = event.address.presence || event.title
    url = "https://maps.apple.com/?q=#{ERB::Util.url_encode(name)}"
    url += "&ll=#{event.latitude},#{event.longitude}" if event.geocoded?
    url
  end

  def waze_maps_url(event)
    if event.geocoded?
      "https://waze.com/ul?ll=#{event.latitude},#{event.longitude}&navigate=yes"
    else
      "https://waze.com/ul?q=#{ERB::Util.url_encode(event.address)}&navigate=yes"
    end
  end
end

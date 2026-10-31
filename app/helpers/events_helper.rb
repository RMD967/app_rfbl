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

  GENRE_PHOTOS = {
    "Tropical" => [
      "https://images.unsplash.com/photo-1545128485-c400e7702796?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1511192336575-5a79af67a629?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=800&q=80"
    ],
    "Cumbia" => [
      "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1545128485-c400e7702796?auto=format&fit=crop&w=800&q=80"
    ],
    "Salsa" => [
      "https://images.unsplash.com/photo-1511192336575-5a79af67a629?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1545128485-c400e7702796?auto=format&fit=crop&w=800&q=80"
    ],
    "Rock" => [
      "https://images.unsplash.com/photo-1465847899084-d164df4dedc6?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1506157786151-b8491531f063?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80"
    ],
    "Pop" => [
      "https://images.unsplash.com/photo-1510915361894-db8b60106cb1?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1501386761578-eac5c94b800a?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1485579149621-3123dd979885?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1429962714451-bb934ecdc4ec?auto=format&fit=crop&w=800&q=80"
    ],
    "DJ" => [
      "https://images.unsplash.com/photo-1571266028243-3716f02d2d2e?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=800&q=80"
    ],
    "Jazz" => [
      "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1415201364774-f6f0bb35f28f?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1520523839898-507121c255d6?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1573871669414-010dbf73ca84?auto=format&fit=crop&w=800&q=80"
    ],
    "Regional" => [
      "https://images.unsplash.com/photo-1518609878373-06d740f60d8b?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1533105079780-92b9be482077?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=800&q=80"
    ],
    "Urban" => [
      "https://images.unsplash.com/photo-1509198397868-475647b2a1e5?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1547153760-18fc86324498?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?auto=format&fit=crop&w=800&q=80"
    ],
    "Country" => [
      "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1485579149621-3123dd979885?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1465847899084-d164df4dedc6?auto=format&fit=crop&w=800&q=80"
    ],
    "Ballads" => [
      "https://images.unsplash.com/photo-1485579149621-3123dd979885?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1510915361894-db8b60106cb1?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1520523839898-507121c255d6?auto=format&fit=crop&w=800&q=80"
    ],
    "Instrumental" => [
      "https://images.unsplash.com/photo-1520523839898-507121c255d6?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1465847899084-d164df4dedc6?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80"
    ],
    "Choir" => [
      "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1520523839898-507121c255d6?auto=format&fit=crop&w=800&q=80"
    ]
  }.freeze

  def event_cover_image_url(event)
    return url_for(event.image) if event.image.attached?

    genre_key = GENRE_PHOTOS.keys.find { |k| k.casecmp?(event.genre.to_s.strip) } || "Pop"
    photos = GENRE_PHOTOS[genre_key] || GENRE_PHOTOS["Pop"]

    # Deterministic rotation based on event ID
    index = (event.id || 0) % photos.length
    photos[index]
  end

  def organizer_avatar_url(user)
    return url_for(user.profile_picture) if user.respond_to?(:profile_picture) && user.profile_picture.attached?

    avatars = [
      "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=75&fm=webp",
      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=75&fm=webp",
      "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=75&fm=webp",
      "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=75&fm=webp",
      "https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=200&q=75&fm=webp",
      "https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=200&q=75&fm=webp",
      "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?auto=format&fit=crop&w=200&q=75&fm=webp"
    ]
    avatars[(user.id || 0) % avatars.length]
  end
end

# db/seeds.rb - High-performance, realistic & WebP-optimized dataset for Radios FBL

puts "🧹 Cleaning existing database records..."
Favorite.destroy_all if defined?(Favorite)
Follow.destroy_all if defined?(Follow)
Message.destroy_all
ChatUser.destroy_all
Chatroom.destroy_all
Booking.destroy_all
Comment.destroy_all
Like.destroy_all
Discover.destroy_all
UserDashboard.destroy_all if defined?(UserDashboard)
Dashboard.destroy_all
Event.destroy_all
User.destroy_all

# Optimized video streams with Cloudinary auto-compression & 480p mobile width
CLD_VIDEOS = [
  "https://res.cloudinary.com/djuhjudsb/video/upload/q_auto:good,w_480,vc_h264/v1687812814/main_nari6s.mp4",
  "https://res.cloudinary.com/djuhjudsb/video/upload/q_auto:good,w_480,vc_h264/v1687812793/2_bldgkm.mp4",
  "https://res.cloudinary.com/djuhjudsb/video/upload/q_auto:good,w_480,vc_h264/v1687812806/1_qqcb2j.mp4",
  "https://res.cloudinary.com/djuhjudsb/video/upload/q_auto:good,w_480,vc_h264/v1687812797/6_jrd8xr.mp4",
  "https://res.cloudinary.com/djuhjudsb/video/upload/q_auto:good,w_480,vc_h264/v1687812817/3_qu4iul.mp4",
  "https://res.cloudinary.com/djuhjudsb/video/upload/q_auto:good,w_480,vc_h264/v1687812801/5_jjdgww.mp4",
  "https://res.cloudinary.com/djuhjudsb/video/upload/q_auto:good,w_480,vc_h264/v1687812827/7_s5cbyd.mp4",
  "https://res.cloudinary.com/djuhjudsb/video/upload/q_auto:good,w_480,vc_h264/v1687812802/8_se9d9t.mp4",
  "https://res.cloudinary.com/djuhjudsb/video/upload/q_auto:good,w_480,vc_h264/v1687812838/9_ylmvbr.mp4",
  "https://res.cloudinary.com/djuhjudsb/video/upload/q_auto:good,w_480,vc_h264/v1687812794/10_jgfbdr.mp4",
  "https://res.cloudinary.com/djuhjudsb/video/upload/q_auto:good,w_480,vc_h264/v1687812806/4_dqztvb.mp4"
].freeze

# High-efficiency WebP portrait avatars
WEBP_AVATARS = [
  "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1501196354995-cbb51c65aaea?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1517457373958-b7bdd4587205?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1463453091185-61582044d556?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1517256673644-36ad11246d21?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?auto=format&fit=crop&w=400&q=75&fm=webp",
  "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=75&fm=webp"
].freeze

puts "👤 Creating demo user..."
demo_user = User.create!(
  email: "user0@example.com",
  password: "12345678",
  password_confirmation: "12345678",
  first_name: "Damian",
  last_name: "Reyes",
  artist: false
)

puts "🎭 Creating Event Organizers / Venues..."
organizers_catalog = [
  { first: "Sarah", last: "Jenkins", email: "sarah.rooftop@example.com", venue: "The Skyline Rooftop Lounge" },
  { first: "Diego", last: "Morales", email: "diego.fiesta@example.com", venue: "Casa de la Salsa Puebla" },
  { first: "Olivia", last: "Chen", email: "olivia.weddings@example.com", venue: "Bliss Wedding Planners" },
  { first: "Marcus", last: "Vance", email: "marcus.lounge@example.com", venue: "Blue Note Jazz Cellar" },
  { first: "Elena", last: "Gomez", email: "elena.festival@example.com", venue: "Sunset Music Festivals" },
  { first: "Lucas", last: "Rossi", email: "lucas.beach@example.com", venue: "Paradise Beach Club" },
  { first: "Mateo", last: "Campos", email: "mateo.puebla@example.com", venue: "Terraza Cholula Live" },
  { first: "Valeria", last: "Cruz", email: "valeria.cdmx@example.com", venue: "Foro Condesa Underground" },
  { first: "Fernando", last: "Soto", email: "fernando.gdl@example.com", venue: "Palacio de la Música Zapopan" },
  { first: "Camila", last: "Rios", email: "camila.mty@example.com", venue: "Arena San Pedro Music" },
  { first: "Javier", last: "Lara", email: "javier.cancun@example.com", venue: "Riviera Beach Stage" },
  { first: "Sofia", last: "Mendoza", email: "sofia.oaxaca@example.com", venue: "Centro Cultural Oaxaca" }
]

organizers = organizers_catalog.map do |data|
  User.create!(
    email: data[:email],
    password: "12345678",
    first_name: data[:first],
    last_name: data[:last],
    artist: false
  )
end

puts "🎸 Generating ~100 Musicians & Dashboards across Puebla, CDMX, Miami, NY and key hubs..."

GENRES = %w[Tropical Regional Rock Pop Urban DJ Jazz Ballads Instrumental Choir Country].freeze

LOCATIONS_CONFIG = {
  "Puebla" => {
    cities: "Puebla, San Andrés Cholula, Atlixco, Tehuacán",
    venues: ["Zócalo de Puebla", "San Andrés Cholula", "Angelópolis", "La Paz", "Teatro Principal Puebla"]
  },
  "Ciudad de México" => {
    cities: "Ciudad de México, Naucalpan, Tlalnepantla",
    venues: ["Roma Norte", "Condesa", "Polanco", "Coyoacán", "Centro Histórico CDMX"]
  },
  "Guadalajara" => {
    cities: "Guadalajara, Zapopan, Tlaquepaque",
    venues: ["Chapultepec GDL", "Providencia", "Teatro Degollado"]
  },
  "Monterrey" => {
    cities: "Monterrey, San Pedro Garza García, Santa Catarina",
    venues: ["Barrio Antiguo MTY", "San Pedro Garza García", "Parque Fundidora"]
  },
  "Cancún" => {
    cities: "Cancún, Playa del Carmen, Tulum",
    venues: ["Zona Hotelera Cancún", "Quinta Avenida Playa", "Tulum Jungle Stage"]
  },
  "Oaxaca" => {
    cities: "Oaxaca de Juárez, Santa Cruz Xoxocotlán",
    venues: ["Andador Turístico Oaxaca", "Jardín Etnobotánico"]
  },
  "Miami" => {
    cities: "Miami, Miami Beach, Fort Lauderdale",
    venues: ["Ocean Drive Miami Beach", "Wynwood Arts District", "Brickell Avenue"]
  },
  "New York" => {
    cities: "New York, Brooklyn, Queens",
    venues: ["5th Avenue Manhattan", "Williamsburg Brooklyn", "Greenwich Village"]
  },
  "Los Angeles" => {
    cities: "Los Angeles, Santa Monica, Pasadena",
    venues: ["Hollywood Blvd", "Sunset Strip West Hollywood", "Santa Monica Pier"]
  },
  "Austin" => {
    cities: "Austin, San Antonio, Round Rock",
    venues: ["6th Street Austin", "Rainey Street", "Zilker Park"]
  },
  "Nashville" => {
    cities: "Nashville, Franklin, Murfreesboro",
    venues: ["Broadway Nashville", "Music Row", "Ryman Auditorium"]
  }
}.freeze

# Specific high-profile seed artists
ARTIST_NAMES_BY_GENRE = {
  "Tropical" => [
    "Sonora Tropical Angelópolis", "Cumbia Sonidera Fantasma", "Salsa Candela Puebla",
    "Los Reyes de la Cumbia 90s", "Orquesta Rumba del Sol", "Sabor Caribe Ensamble",
    "Sonidero Mayor de Cholula", "Bachatéame Mucho", "Ritmo & Melao", "La Clave Tropical",
    "Cumbia & Brass All Stars", "Guaracha Soundsystem", "Tumbao de Barrio", "Salsa Brava Band"
  ],
  "Regional" => [
    "Mariachi Angelópolis Imperial", "Mariachi Los Gavilanes", "Banda Sinaloense La Poblana",
    "Trío Huasteco Raíces", "Norteño Los Hermanos Vega", "Mariachi Clásico de Puebla",
    "Grupo Sabor de la Sierra", "Los Bravos del Bajío"
  ],
  "Rock" => [
    "Carlos Santana Tribute Band", "Los Hijos del Volcán", "Distorsión Poblana",
    "Retro Rock 80s & 90s", "Furia & Cuerdas", "Electric Shadow Band",
    "Rock Urbano 5 de Mayo", "The Neon Voltage"
  ],
  "Pop" => [
    "The Neon Vibe", "Luna Pop Acústico", "Synthwave Avenue", "Aurora & The Echoes",
    "Velvet Sunset Pop", "Modern Melodies Co.", "Prisma Pop Trío"
  ],
  "Urban" => [
    "Urban Beats Collective", "Flow Angelopolitano", "Trap Latino Puebla",
    "Rhythm & Rhymes CDMX", "La Manada Urbana", "Bassline Warriors"
  ],
  "DJ" => [
    "DJ Alex Pulse", "Electro Cumbia Angelopolitana", "DJ Solarise Melodic",
    "Deep House Cholula Session", "Tech House Project MTY", "DJ Maya Tropical Beat"
  ],
  "Jazz" => [
    "Luna & The Midnight Grooves", "Puebla Jazz Quartet", "Blue Note Trio",
    "Smooth Sax & Rhodes", "Bossa Nova Sessions GDL", "Latin Jazz Ensamble"
  ],
  "Ballads" => [
    "Sophia Acoustic Sunset", "Noches Románticas en Cholula", "Cuerdas del Alma",
    "Acoustic Duo Romance", "Voz & Guitarra Íntima", "Serenatas de Luna"
  ],
  "Instrumental" => [
    "Elena Rostova Strings", "Velvet String Quartet", "Guitarras Clásicas Angelópolis",
    "Piano & Cello Serenade", "Solistas de Puebla Ensemble"
  ],
  "Choir" => [
    "Coro Polifónico Armonía", "Coro Monumental de Puebla", "Voces en Armonía Angelópolis",
    "Ensamble Coral Filadelfia"
  ],
  "Country" => [
    "Echoes of Nashville", "Texas Lone Star Band", "Bluegrass & Banjo Riders",
    "Country Highway Road"
  ]
}.freeze

instruments_by_genre = {
  "Tropical" => ["Drums", "Congas", "Vocals", "Trumpet", "Bass", "Timbales", "Keyboard"],
  "Regional" => ["Trumpet", "Violin", "Guitar", "Guitarrón", "Accordion", "Vocals"],
  "Rock" => ["Guitar", "Bass", "Drums", "Vocals", "Keyboard"],
  "Pop" => ["Vocals", "Synthesizer", "Guitar", "Bass", "Drums"],
  "Urban" => ["DJ", "MPC", "Vocals", "Synthesizer"],
  "DJ" => ["DJ", "Pioneer CDJ", "Turntables", "Synthesizer"],
  "Jazz" => ["Saxophone", "Trumpet", "Upright Bass", "Piano", "Drums", "Guitar"],
  "Ballads" => ["Acoustic Guitar", "Piano", "Vocals"],
  "Instrumental" => ["Violin", "Cello", "Classical Guitar", "Piano"],
  "Choir" => ["Vocals", "Choral", "Piano"],
  "Country" => ["Guitar", "Banjo", "Fiddle", "Pedal Steel"]
}

artist_index = 0
all_artist_records = []

# Generate ~100 distinct artists (heavily featuring Puebla and Tropical as requested)
GENRES.each do |genre|
  artist_names = ARTIST_NAMES_BY_GENRE[genre] || ["#{genre} Ensamble"]
  
  artist_names.each do |artist_name|
    artist_index += 1
    
    # Prioritize Puebla for 30%+ of the artists, otherwise rotate key hubs
    location = if artist_index % 3 == 0 || artist_name.downcase.include?("puebla") || artist_name.downcase.include?("cholula") || artist_name.downcase.include?("angelópolis")
                 "Puebla"
               else
                 LOCATIONS_CONFIG.keys.sample
               end

    loc_data = LOCATIONS_CONFIG[location]
    first_name = artist_name.split.first
    last_name = "Artista_#{artist_index}"
    email = "artist_#{artist_index}@rfbl-music.com"

    user = User.create!(
      email: email,
      password: "12345678",
      first_name: first_name,
      last_name: last_name,
      artist: true
    )

    inst = (instruments_by_genre[genre] || ["Instruments"]).sample
    price = rand(300..1200)

    desc = "#{artist_name} presenta su propuesta musical única en vivo. Especialistas en eventos privados, festivales y presentaciones de primer nivel en #{location} y alrededores."

    dash = Dashboard.create!(
      user: user,
      artist_name: artist_name,
      artist_genre: genre,
      artist_instrument: inst,
      artist_location: location,
      artist_travel: true,
      artist_radius: rand(40..100),
      artist_cities: loc_data[:cities],
      artist_description: desc,
      artist_price: price,
      artist_count: rand(1..8)
    )

    UserDashboard.create!(user: user, dashboard: dash) if defined?(UserDashboard)
    all_artist_records << { user: user, dashboard: dash, genre: genre, location: location, name: artist_name }
  end
end

puts "✅ Created #{all_artist_records.size} Artist Dashboards."

puts "🎵 Generating ~550 Discover Videos with WebP & Cloudinary optimization..."

MUSIC_TRACK_PREFIXES = {
  "Tropical" => ["Cumbia Sabrosa", "Noche de Salsa Dura", "Ritmo de Cholula", "Sabor Costeño", "Baila Sin Parar", "El Sonidero", "Fuego & Clave", "La Cumbia de los Recuerdos"],
  "Regional" => ["El Son de la Madrugada", "Cielito Lindo en Vivo", "Serenata Poblana", "El Mariachi Loco", "El Rey en Concierto", "Mi Lindo México"],
  "Rock" => ["Black Magic Samba", "Distorsión & Fuego", "Noche Eléctrica", "Guitarras al Límite", "Bajo el Volcán", "Rock City Beats"],
  "Pop" => ["Summer Electric", "Luces de Neón", "Ecos de Ti", "Melodías en la Noche", "Vuelo Alto", "Latidos Pop"],
  "Urban" => ["City Lights & 808s", "Fuego Callejero", "Ritmo Pesado", "Flow del Barrio", "Noche de Trap", "Urbano Style"],
  "DJ" => ["Neon Horizons", "Cholula Sunset Mix", "Deep Pulse Sessions", "Club Euphoria", "Techno Groove", "Sunrise Melodic Drop"],
  "Jazz" => ["Midnight Boulevard", "Blue Note Serenade", "Café de Noche", "Sax & Moon", "Rhythm & Brass", "Autumn Leaves Solo"],
  "Ballads" => ["Golden Gate Sunset", "Promesa al Corazón", "Bajo las Estrellas", "Aroma de Café", "Tu Mirada", "Acústico en Silencio"],
  "Instrumental" => ["Czardas & Modern Strings", "Bridgerton Serenade", "Sinfonía Angelopolitana", "Cuerdas del Viento", "Piano Nocturno"],
  "Choir" => ["Voices in Harmony", "Canto Sacro", "Polifonía Celestial", "Aleluya en Concierto"],
  "Country" => ["Tennessee Highway Road", "Country Hoedown", "Southern Sunset", "Dusty Boots"]
}.freeze

GENERAL_POST_TITLES = [
  "Detrás de cámaras ensayando para el festival de fin de semana 🎸🔥",
  "Probando nuevo equipo y arreglos en el estudio de grabación 🎛️🎧",
  "¡Gracias a toda la banda por una noche inolvidable en vivo! Nos vemos pronto 🙌✨",
  "Calentando voces y cuerdas antes de subir al escenario 🎶 backstage vibe",
  "Soundcheck listo antes de reventar el escenario esta noche 🚀🎤",
  "Componiendo nuevas melodías frente al volcán Popocatépetl 🌋🎼",
  "En vivo desde la prueba de audio, la acústica de este foro está tremenda 🔊🎵"
].freeze

discover_count = 0

all_artist_records.each do |art|
  # Create 4 to 6 discover items per artist to reach ~550 total
  track_pool = MUSIC_TRACK_PREFIXES[art[:genre]] || ["Track en Vivo"]
  
  num_posts = rand(4..6)
  num_posts.times do |p_idx|
    is_general = (p_idx == num_posts - 1)
    
    title = if is_general
              GENERAL_POST_TITLES.sample
            else
              "#{track_pool.sample} - #{art[:name]}"
            end

    post_type = is_general ? "general" : "music"
    video_url = CLD_VIDEOS.sample

    disc = Discover.new(
      dashboard: art[:dashboard],
      title: title,
      content: video_url,
      genre: art[:genre],
      post_type: post_type,
      plays: rand(4500..890000),
      saved: [true, false].sample,
      start_time: 0.0,
      end_time: is_general ? 30.0 : 45.0
    )
    disc[:likes] = rand(400..65000)
    disc.save!
    discover_count += 1
  end
end

puts "✅ Created #{discover_count} Discover Video Posts."

puts "📅 Generating ~220 Geolocated Live Events across Puebla, CDMX, Miami, etc..."

EVENT_TEMPLATES_BY_GENRE = {
  "Tropical" => [
    { title: "Noche de Salsa & Cumbia Caliente", desc: "Gran baile con orquesta en vivo, pista de baile techada y ambiente festivo." },
    { title: "Festival de Cumbia Sonidera Angelópolis", desc: "El mejor cartel de cumbia y sonidero en vivo para bailar toda la noche." },
    { title: "Fiesta Latina & Noche Tropical", desc: "Show en vivo de música tropical, coctelería caribeña y DJ de apoyo." }
  ],
  "Regional" => [
    { title: "Gran Noche Mexicana & Mariachi Show", desc: "Serenatas tradicionales, trompetas enérgicas y fiesta con mariachi completo." },
    { title: "Tardeada Ranchera & Fiesta Patronal", desc: "Música vernácula y regional en vivo para toda la familia." }
  ],
  "Rock" => [
    { title: "Classic Rock Fest en Vivo", desc: "Guitarras potentes, tributos a los grandes del rock y sonido de alto voltaje." },
    { title: "Noche de Indie Rock & Alternativo", desc: "Bandas emergentes y consolidadas en el mejor foro de música en directo." }
  ],
  "Pop" => [
    { title: "Pop & Synth Sunset Party", desc: "Hits contemporáneos, sintetizadores y fiesta en terraza con vista panorámica." },
    { title: "Acoustic Pop Showcase", desc: "Voces y melodías pop en un formato íntimo para amantes de la buena música." }
  ],
  "Urban" => [
    { title: "Urban Block Party & Trap Sessions", desc: "Showcase urbano con los mejores exponentes de rap, trap y reggaetón." },
    { title: "Freestyle & Beatmakers Night", desc: "Competencia de rimas, productores en vivo y ambiente 100% urbano." }
  ],
  "DJ" => [
    { title: "Sunset Rooftop Melodic DJ Set", desc: "Deep house, progressive y electrónica melódica para despedir la puesta de sol." },
    { title: "Club Night Tech House Sessions", desc: "Bajos profundos y pista encendida hasta el amanecer." }
  ],
  "Jazz" => [
    { title: "Saturday Night Jazz & Wine Cellar", desc: "Cena maridaje con cuarteto de jazz en vivo y estándares clásicos." },
    { title: "Latin Jazz & Bossa Nova Evening", desc: "Fusión de jazz y ritmos caribeños en un espacio exclusivo." }
  ],
  "Ballads" => [
    { title: "Noche de Baladas & Boleros Bajo las Estrellas", desc: "Serenata romántica a la luz de las velas con guitarra y piano acústico." },
    { title: "Acoustic Singer-Songwriter Showcase", desc: "Historias y canciones a corazón abierto en formato acústico." }
  ],
  "Instrumental" => [
    { title: "Concierto de Cuerdas Clásicas & Pop Covers", desc: "Arreglos orquestales modernos estilo Bridgerton para una noche elegante." },
    { title: "Recital de Guitarra Clásica & Violín", desc: "Virtuosismo instrumental en un marco acústico de primera calidad." }
  ],
  "Choir" => [
    { title: "Gala Coral Monumental", desc: "Polifonía vocal y armonías corales con más de 15 intérpretes en escena." }
  ],
  "Country" => [
    { title: "Country BBQ & Honky Tonk Jamboree", desc: "Guitarras con slide, violines y el mejor ambiente country en vivo." }
  ]
}.freeze

PUEBLA_EVENT_LOCATIONS = [
  { addr: "Portal Hidalgo 14, Centro Histórico, 72000 Puebla, Pue., México", lat: 19.0433, lng: -98.1983 },
  { addr: "Calle 14 Oriente 801, San Andrés Cholula, 72810 Puebla, Pue., México", lat: 19.0621, lng: -98.3075 },
  { addr: "Blvd. del Niño Poblano 2510, Reserva Territorial Atlixcáyotl, 72197 Puebla, Pue., México", lat: 19.0305, lng: -98.2325 },
  { addr: "Av. Juárez 2108, La Paz, 72160 Puebla, Pue., México", lat: 19.0520, lng: -98.2160 },
  { addr: "Blvd. Atlixco 3156, Las Ánimas, 72400 Puebla, Pue., México", lat: 19.0380, lng: -98.2310 },
  { addr: "Calle 6 Norte 402, Barrio del Artista, 72000 Puebla, Pue., México", lat: 19.0440, lng: -98.1945 },
  { addr: "Av. 5 Poniente 308, Centro, 72000 Puebla, Pue., México", lat: 19.0425, lng: -98.2010 }
].freeze

CDMX_EVENT_LOCATIONS = [
  { addr: "Av. Álvaro Obregón 160, Roma Norte, 06700 Ciudad de México, CDMX, México", lat: 19.4180, lng: -99.1610 },
  { addr: "Av. Tamaulipas 130, Condesa, 06140 Ciudad de México, CDMX, México", lat: 19.4110, lng: -99.1750 },
  { addr: "Campos Elíseos 204, Polanco, 11560 Ciudad de México, CDMX, México", lat: 19.4290, lng: -99.1920 },
  { addr: "Jardín Centenario 1, Coyoacán, 04000 Ciudad de México, CDMX, México", lat: 19.3490, lng: -99.1620 }
].freeze

MIAMI_EVENT_LOCATIONS = [
  { addr: "1601 Ocean Dr, Miami Beach, FL 33139, USA", lat: 25.7891, lng: -80.1301 },
  { addr: "2550 NW 2nd Ave, Miami, FL 33127, USA", lat: 25.8015, lng: -80.1990 },
  { addr: "1421 S Miami Ave, Miami, FL 33130, USA", lat: 25.7600, lng: -80.1930 }
].freeze

NEW_YORK_EVENT_LOCATIONS = [
  { addr: "131 W 3rd St, New York, NY 10012, USA", lat: 40.7308, lng: -74.0007 },
  { addr: "350 5th Ave, New York, NY 10118, USA", lat: 40.7484, lng: -73.9857 },
  { addr: "260 Bedford Ave, Brooklyn, NY 11211, USA", lat: 40.7140, lng: -73.9600 }
].freeze

event_count = 0
organizers_cycle = organizers.cycle

GENRES.each do |genre|
  templates = EVENT_TEMPLATES_BY_GENRE[genre] || [{ title: "Noche Musical de #{genre}", desc: "Gran presentación en vivo." }]
  
  # Generate 18 to 24 events per genre = ~220 events total
  rand(18..24).times do |e_idx|
    tmpl = templates.sample
    organizer = organizers_cycle.next

    # Prioritize Puebla locations (at least 40% of all events in Puebla)
    loc_sample = if e_idx % 2 == 0
                   PUEBLA_EVENT_LOCATIONS.sample
                 elsif e_idx % 3 == 0
                   CDMX_EVENT_LOCATIONS.sample
                 elsif e_idx % 5 == 0
                   MIAMI_EVENT_LOCATIONS.sample
                 else
                   NEW_YORK_EVENT_LOCATIONS.sample
                 end

    city_tag = if loc_sample[:addr].include?("Puebla")
                 "Puebla"
               elsif loc_sample[:addr].include?("Ciudad de México")
                 "CDMX"
               elsif loc_sample[:addr].include?("Miami")
                 "Miami"
               else
                 "New York"
               end

    event_date = Time.current + rand(1..85).days + rand(10..23).hours

    ev = Event.new(
      user: organizer,
      title: "#{tmpl[:title]} (#{city_tag})",
      description: "#{tmpl[:desc]} Organizado en #{loc_sample[:addr].split(',').first}. ¡No te lo pierdas!",
      genre: genre,
      duration: [90, 120, 150, 180, 240].sample,
      address: loc_sample[:addr],
      latitude: loc_sample[:lat] + (rand(-10..10) * 0.0008),
      longitude: loc_sample[:lng] + (rand(-10..10) * 0.0008),
      datetime: event_date
    )
    # Save without triggering geocoding network calls
    ev.save!(validate: false)
    event_count += 1
  end
end

puts "✅ Created #{event_count} Live Events."

puts "💬 Adding realistic social engagement (Comments & Likes)..."

SAMPLE_COMMENTS = [
  "¡Qué talento hermano! Sonando con una energía tremenda 🔥",
  "Ese ritmo se siente hasta acá en Puebla, ¡felicidades!",
  "¿En qué parte de Cholula se van a presentar este fin de semana?",
  "¡Qué buena rola! Ya la agregué a mi lista de favoritos 🎵",
  "Impresionante la calidad de sonido y la voz, mis respetos.",
  "¡Mucho éxito amigos! Tienen que tocar en el Zócalo pronto 🙌",
  "Pura sabrosura tropical, ¡esto sí es música para bailar!",
  "La producción y los arreglos están de otro nivel ✨",
  "El solo del minuto 0:30 me dejó con la boca abierta 🎸",
  "Saludos desde Puebla capital, ¡suenen con todo!",
  "¡Venga esa cumbia! Me hicieron el día con este video 🎉",
  "Recomendadísimos para cualquier evento privado, suenan genial."
].freeze

SAMPLE_REPLIES = [
  "¡Muchas gracias por la buena vibra! Saludos a toda la gente de Puebla 🙌",
  "¡Mil gracias amigo! Nos vemos en el próximo concierto en vivo 🎶",
  "¡Claro que sí! Escríbenos por mensaje directo para contrataciones o fechas.",
  "¡Gracias por escuchar! Vienen muchas canciones nuevas pronto 🔥"
].freeze

all_discovers = Discover.all.to_a
users_pool = User.all.to_a

all_discovers.sample(150).each do |disc|
  rand(2..5).times do
    commenter = users_pool.sample
    comm = Comment.create!(
      discover: disc,
      user: commenter,
      content: SAMPLE_COMMENTS.sample
    )

    # Likes on comments
    rand(1..4).times do
      users_pool.sample.like(comm)
    end

    # Reply to comment
    if [true, false].sample
      Comment.create!(
        discover: disc,
        parent: comm,
        user: disc.dashboard.user,
        content: SAMPLE_REPLIES.sample
      )
    end
  end

  # Likes on discover video
  rand(3..9).times do
    users_pool.sample.like(disc)
  end
end

puts "✨ SEEDING COMPLETE! ✨"
puts "📊 Total Users: #{User.count}"
puts "📊 Total Artists / Dashboards: #{Dashboard.count}"
puts "📊 Total Discover Videos: #{Discover.count}"
puts "📊 Total Events: #{Event.count}"
puts "📊 Total Comments: #{Comment.count}"
puts "📊 Total Likes: #{Like.count}"

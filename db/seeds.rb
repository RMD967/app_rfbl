# db/seeds.rb - Realistic dataset for Radios FBL

puts "🧹 Cleaning old database records..."
Favorite.destroy_all if defined?(Favorite)
Follow.destroy_all if defined?(Follow)
Message.destroy_all
ChatUser.destroy_all
Chatroom.destroy_all
Booking.destroy_all
Discover.destroy_all
Dashboard.destroy_all
Event.destroy_all
User.destroy_all

puts "👤 Creating demo user..."
# Default demo user for instant login
demo_user = User.create!(
  email: "user0@example.com",
  password: "12345678",
  password_confirmation: "12345678",
  first_name: "Damian",
  last_name: "Reyes",
  artist: false
)

puts "🎭 Creating Event Organizers / Venues..."
organizers_data = [
  { first: "Sarah", last: "Jenkins", email: "sarah.rooftop@example.com", venue: "The Skyline Rooftop Lounge" },
  { first: "Diego", last: "Morales", email: "diego.fiesta@example.com", venue: "Casa de la Salsa" },
  { first: "Olivia", last: "Chen", email: "olivia.weddings@example.com", venue: "Bliss Wedding Planners" },
  { first: "Marcus", last: "Vance", email: "marcus.lounge@example.com", venue: "Blue Note Jazz Cellar" },
  { first: "Elena", last: "Gomez", email: "elena.festival@example.com", venue: "Sunset Music Festivals" },
  { first: "Lucas", last: "Rossi", email: "lucas.beach@example.com", venue: "Paradise Beach Club" }
]

organizers = organizers_data.map do |data|
  User.create!(
    email: data[:email],
    password: "12345678",
    first_name: data[:first],
    last_name: data[:last],
    artist: false
  )
end

puts "🎸 Creating Musicians & Artist Dashboards..."
artists_dataset = [
  {
    name: "Luna & The Midnight Grooves",
    first: "Luna", last: "Valdez", email: "luna.grooves@example.com",
    genre: "Jazz", instrument: "Vocals", location: "New York",
    cities: "New York, Philadelphia, Boston",
    price: 650.00, count: 4, radius: 60.0,
    desc: "Smooth modern jazz quartet blending soulful vocals with upright bass, saxophone, and vintage Rhodes piano. Perfect for upscale lounges and cocktail receptions.",
    video: "https://res.cloudinary.com/djuhjudsb/video/upload/v1687812814/main_nari6s.mp4",
    track: "Midnight Boulevard",
    avatar: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80"
  },
  {
    name: "DJ Alex Pulse",
    first: "Alex", last: "Pulse", email: "alex.pulse@example.com",
    genre: "DJ", instrument: "DJ", location: "Miami",
    cities: "Miami, Fort Lauderdale, Orlando",
    price: 550.00, count: 1, radius: 80.0,
    desc: "High-energy club and festival DJ specializing in Deep House, Tech-House, and Tropical Latin beats. Full sound system and Pioneer CDJ setup included.",
    video: "https://res.cloudinary.com/djuhjudsb/video/upload/v1687812793/2_bldgkm.mp4",
    track: "Neon Horizons (Live Mix)",
    avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=80"
  },
  {
    name: "Mariachi Los Gavilanes",
    first: "Javier", last: "Mendoza", email: "mariachi.gavilanes@example.com",
    genre: "Regional", instrument: "Trumpet", location: "Los Angeles",
    cities: "Los Angeles, San Diego, Anaheim",
    price: 850.00, count: 7, radius: 75.0,
    desc: "Authentic 7-piece Mexican Mariachi ensemble with trumpets, violins, vihuela, and guitarrón. Traditional rancheras, boleros, and festive serenades.",
    video: "https://res.cloudinary.com/djuhjudsb/video/upload/v1687812806/1_qqcb2j.mp4",
    track: "El Son de la Madrugada",
    avatar: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&auto=format&fit=crop&q=80"
  },
  {
    name: "Carlos Santana Tribute Trio",
    first: "Mateo", last: "Santana", email: "mateo.guitar@example.com",
    genre: "Rock", instrument: "Guitar", location: "San Francisco",
    cities: "San Francisco, Oakland, San Jose",
    price: 500.00, count: 3, radius: 50.0,
    desc: "Latin rock fusion trio featuring electrifying guitar solos, congas, and driving basslines that will keep crowds dancing all night.",
    video: "https://res.cloudinary.com/djuhjudsb/video/upload/v1687812797/6_jrd8xr.mp4",
    track: "Black Magic Samba",
    avatar: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500&auto=format&fit=crop&q=80"
  },
  {
    name: "Elena Rostova",
    first: "Elena", last: "Rostova", email: "elena.violin@example.com",
    genre: "Instrumental", instrument: "Violin", location: "Chicago",
    cities: "Chicago, Milwaukee, Evanston",
    price: 380.00, count: 1, radius: 45.0,
    desc: "Classically trained concert violinist performing classical masterworks as well as contemporary pop/rock arrangements on acoustic and electric violin.",
    video: "https://res.cloudinary.com/djuhjudsb/video/upload/v1687812817/3_qu4iul.mp4",
    track: "Czardas & Modern Strings",
    avatar: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500&auto=format&fit=crop&q=80"
  },
  {
    name: "The Neon Vibe",
    first: "Liam", last: "Brooks", email: "liam.vibe@example.com",
    genre: "Pop", instrument: "Bass Guitar", location: "Austin",
    cities: "Austin, San Antonio, Houston",
    price: 600.00, count: 4, radius: 70.0,
    desc: "Modern indie-pop band delivering upbeat festival anthems, synth hooks, and top-40 hits with energetic live performance presence.",
    video: "https://res.cloudinary.com/djuhjudsb/video/upload/v1687812801/5_jjdgww.mp4",
    track: "Summer Electric",
    avatar: "https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=500&auto=format&fit=crop&q=80"
  },
  {
    name: "Salsa & Cumbia Kings",
    first: "Andres", last: "Castillo", email: "andres.cumbia@example.com",
    genre: "Tropical", instrument: "Drums", location: "Miami",
    cities: "Miami, Fort Lauderdale, Tampa",
    price: 750.00, count: 5, radius: 65.0,
    desc: "Dynamic tropical orchestra playing the best of classic salsa dura, Colombian cumbia, and Caribbean bachata guaranteed to fill any dancefloor.",
    video: "https://res.cloudinary.com/djuhjudsb/video/upload/v1687812827/7_s5cbyd.mp4",
    track: "Baila Conmigo",
    avatar: "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=500&auto=format&fit=crop&q=80"
  },
  {
    name: "Sophia Acoustic Sunset",
    first: "Sophia", last: "Taylor", email: "sophia.acoustic@example.com",
    genre: "Ballads", instrument: "Guitar", location: "San Francisco",
    cities: "San Francisco, Berkeley, Palo Alto",
    price: 320.00, count: 1, radius: 35.0,
    desc: "Intimate fingerstyle acoustic guitarist and singer-songwriter performing heartfelt acoustic ballads, folk classics, and romantic wedding serenades.",
    video: "https://res.cloudinary.com/djuhjudsb/video/upload/v1687812802/8_se9d9t.mp4",
    track: "Golden Gate Sunset",
    avatar: "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=500&auto=format&fit=crop&q=80"
  },
  {
    name: "Echoes of Nashville",
    first: "Caleb", last: "Harris", email: "caleb.country@example.com",
    genre: "Country", instrument: "Guitar", location: "Nashville",
    cities: "Nashville, Franklin, Murfreesboro",
    price: 450.00, count: 3, radius: 55.0,
    desc: "Honky-tonk country trio playing timeless country standards, Outlaw country, and contemporary southern rock hits with slide guitar and banjo.",
    video: "https://res.cloudinary.com/djuhjudsb/video/upload/v1687812838/9_ylmvbr.mp4",
    track: "Tennessee Highway Road",
    avatar: "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500&auto=format&fit=crop&q=80"
  },
  {
    name: "Urban Beats Collective",
    first: "Tariq", last: "Johnson", email: "tariq.urban@example.com",
    genre: "Urban", instrument: "DJ", location: "Atlanta",
    cities: "Atlanta, Athens, Savannah",
    price: 520.00, count: 2, radius: 50.0,
    desc: "Hip-Hop, Trap, and R&B producer/DJ duo with live MPC percussion and custom remixed beats for parties, album releases, and corporate events.",
    video: "https://res.cloudinary.com/djuhjudsb/video/upload/v1687812794/10_jgfbdr.mp4",
    track: "City Lights & 808s",
    avatar: "https://images.unsplash.com/photo-1501196354995-cbb51c65aaea?w=500&auto=format&fit=crop&q=80"
  },
  {
    name: "Velvet String Quartet",
    first: "Giselle", last: "Monet", email: "giselle.strings@example.com",
    genre: "Instrumental", instrument: "Cello", location: "Boston",
    cities: "Boston, Cambridge, Providence",
    price: 800.00, count: 4, radius: 60.0,
    desc: "Elite string quartet specializing in luxury gala ceremonies, cocktail hours, Bridgerton-style pop covers, and baroque masterworks.",
    video: "https://res.cloudinary.com/djuhjudsb/video/upload/v1687812814/main_nari6s.mp4",
    track: "Bridgerton Serenade",
    avatar: "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=500&auto=format&fit=crop&q=80"
  },
  {
    name: "Coro Polifónico Armonía",
    first: "Gabriel", last: "Ortiz", email: "gabriel.choir@example.com",
    genre: "Choir", instrument: "Choir", location: "Philadelphia",
    cities: "Philadelphia, Camden, Trenton",
    price: 700.00, count: 12, radius: 40.0,
    desc: "Acclaimed vocal ensemble delivering breathtaking choral harmony, gospel spirituals, sacred ceremonies, and seasonal holiday concerts.",
    video: "https://res.cloudinary.com/djuhjudsb/video/upload/v1687812806/4_dqztvb.mp4",
    track: "Voices in Harmony",
    avatar: "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500&auto=format&fit=crop&q=80"
  }
]

artist_users = []
dashboards = []

artists_dataset.each do |data|
  user = User.create!(
    email: data[:email],
    password: "12345678",
    first_name: data[:first],
    last_name: data[:last],
    artist: true
  )
  artist_users << user

  dashboard = Dashboard.create!(
    user: user,
    artist_name: data[:name],
    artist_genre: data[:genre],
    artist_instrument: data[:instrument],
    artist_location: data[:location],
    artist_travel: true,
    artist_radius: data[:radius],
    artist_cities: data[:cities],
    artist_description: data[:desc],
    artist_price: data[:price],
    artist_count: data[:count]
  )
  dashboards << dashboard
  UserDashboard.create!(user: user, dashboard: dashboard)

  # Create Discover song post for each artist
  Discover.create!(
    dashboard: dashboard,
    title: data[:track],
    content: data[:video],
    genre: data[:genre],
    likes: rand(1500..85000),
    plays: rand(8000..950000),
    saved: [true, false].sample,
    start_time: 0.0,
    end_time: 45.0
  )
end

puts "📅 Creating Live Events across major cities..."
events_data = [
  {
    title: "Sunset Rooftop DJ Session",
    desc: "Seeking an energetic DJ to deliver melodic deep house and downtempo beats as the sun sets over the skyline.",
    genre: "DJ", duration: 180,
    address: "350 5th Ave, New York, NY 10118, USA",
    lat: 40.7484, lng: -73.9857,
    date: Time.current + 2.days + 19.hours
  },
  {
    title: "Saturday Night Live Jazz Night @ The Blue Note",
    desc: "Intimate jazz dinner performance. Looking for a quartet or trio capable of playing classic standards and smooth improvisations.",
    genre: "Jazz", duration: 120,
    address: "131 W 3rd St, New York, NY 10012, USA",
    lat: 40.7308, lng: -74.0007,
    date: Time.current + 4.days + 20.hours
  },
  {
    title: "Noche de Salsa y Cumbia Fiesta",
    desc: "Vibrant Latin dance night at Casa de la Musica. We need a live tropical orchestra to keep 300+ guests moving all night!",
    genre: "Tropical", duration: 240,
    address: "1601 Ocean Dr, Miami Beach, FL 33139, USA",
    lat: 25.7891, lng: -80.1301,
    date: Time.current + 5.days + 21.hours
  },
  {
    title: "Luxury Vineyard Wedding Reception",
    desc: "Looking for an elegant string quartet or acoustic guitar/vocal duo for guest arrival, ceremony, and cocktail hour.",
    genre: "Instrumental", duration: 150,
    address: "1000 Main St, Napa, CA 94559, USA",
    lat: 38.2975, lng: -122.2869,
    date: Time.current + 12.days + 16.hours
  },
  {
    title: "Acoustic Coffeehouse Jam Session",
    desc: "Cozy weekend morning showcase for an authentic acoustic singer-songwriter. Tips and flat fee guaranteed.",
    genre: "Ballads", duration: 90,
    address: "123 Main St, San Francisco, CA 94105, USA",
    lat: 37.7915, lng: -122.3965,
    date: Time.current + 1.day + 11.hours
  },
  {
    title: "Classic Rock Tribute Night @ Electric Lounge",
    desc: "Loud, high-voltage rock show! Need an experienced guitar-driven rock band to headline our Friday stage.",
    genre: "Rock", duration: 150,
    address: "1154 N Western Ave, Chicago, IL 60622, USA",
    lat: 41.9028, lng: -87.6873,
    date: Time.current + 6.days + 21.hours
  },
  {
    title: "Grand Fiesta de Mariachi - 50th Anniversary",
    desc: "Traditional family celebration requiring a top-tier Mariachi group to serenade guests and perform classic rancheras.",
    genre: "Regional", duration: 120,
    address: "6801 Hollywood Blvd, Los Angeles, CA 90028, USA",
    lat: 34.1016, lng: -118.3411,
    date: Time.current + 8.days + 18.hours
  },
  {
    title: "Neon Pop Rooftop Party",
    desc: "Trendy hotel pool deck searching for an upbeat indie-pop or synth-pop act to perform modern hits and originals.",
    genre: "Pop", duration: 120,
    address: "111 E Cesar Chavez St, Austin, TX 78701, USA",
    lat: 30.2629, lng: -97.7431,
    date: Time.current + 7.days + 20.hours
  },
  {
    title: "Country Hoedown & BBQ Festival",
    desc: "Outdoor country festival seeking authentic Nashville country / bluegrass band with fiddles and slide guitar.",
    genre: "Country", duration: 210,
    address: "419 Broadway, Nashville, TN 37203, USA",
    lat: 36.1609, lng: -86.7774,
    date: Time.current + 14.days + 15.hours
  },
  {
    title: "Urban Showcase & Block Party",
    desc: "Outdoor hip-hop and trap showcase for live DJ, beatmakers, and vocal performers. Huge crowd expected.",
    genre: "Urban", duration: 180,
    address: "680 Murphy Ave SW, Atlanta, GA 30310, USA",
    lat: 33.7259, lng: -84.4172,
    date: Time.current + 9.days + 19.hours
  },
  {
    title: "Choral Christmas Gala & Cathedral Symphony",
    desc: "Holiday concert series at historic cathedral. Need a talented 10+ person choir for sacred polyphonic pieces.",
    genre: "Choir", duration: 120,
    address: "1723 Race St, Philadelphia, PA 19103, USA",
    lat: 39.9575, lng: -75.1691,
    date: Time.current + 20.days + 19.hours
  },
  {
    title: "Corporate Innovation Summit Cocktail Gala",
    desc: "Tech summit VIP networking reception requiring an elite instrumental soloist or classical ensemble.",
    genre: "Instrumental", duration: 120,
    address: "650 Townsend St, San Francisco, CA 94103, USA",
    lat: 37.7712, lng: -122.4042,
    date: Time.current + 10.days + 18.hours
  }
]

created_events = []
events_data.each_with_index do |ev, i|
  organizer = organizers[i % organizers.length]
  event = Event.new(
    user: organizer,
    title: ev[:title],
    description: ev[:desc],
    genre: ev[:genre],
    duration: ev[:duration],
    address: ev[:address],
    latitude: ev[:lat],
    longitude: ev[:lng],
    datetime: ev[:date]
  )
  # Save without re-triggering network geocode
  event.save!(validate: false)
  created_events << event
end

puts "🤝 Creating Bookings and Gig Requests..."
# Connect some musicians to events with confirmed & pending bookings
booking_pairs = [
  { artist_idx: 0, event_idx: 1, status: true },   # Luna booked for Blue Note Jazz Night
  { artist_idx: 1, event_idx: 0, status: true },   # Alex Pulse booked for Rooftop DJ
  { artist_idx: 2, event_idx: 6, status: true },   # Mariachi booked for 50th Fiesta
  { artist_idx: 6, event_idx: 2, status: true },   # Salsa Kings booked for Casa de la Salsa
  { artist_idx: 3, event_idx: 5, status: false },  # Carlos Santana applied to Rock Night
  { artist_idx: 4, event_idx: 3, status: false },  # Elena applied to Vineyard Wedding
  { artist_idx: 5, event_idx: 7, status: false },  # The Neon Vibe applied to Neon Pop
  { artist_idx: 7, event_idx: 4, status: false },  # Sophia applied to Coffeehouse Jam
  { artist_idx: 8, event_idx: 8, status: false },  # Caleb applied to Country Hoedown
  { artist_idx: 9, event_idx: 9, status: false }   # Tariq applied to Urban Showcase
]

booking_pairs.each do |bp|
  artist_user = artist_users[bp[:artist_idx]]
  target_event = created_events[bp[:event_idx]]

  Booking.create!(
    user: artist_user,
    event: target_event,
    date: target_event.datetime.to_date,
    status: bp[:status]
  )
end

# Also give demo_user (Damian) an active booking as organizer
Booking.create!(
  user: artist_users[3],
  event: created_events.first,
  date: created_events.first.datetime.to_date,
  status: true
)

puts "💬 Creating Active Real-Time Chatrooms & Messages..."
chat_conversations = [
  {
    organizer: organizers[0], # Sarah Jenkins (Rooftop Lounge)
    artist: artist_users[1],   # DJ Alex Pulse
    event: created_events[0],
    messages: [
      { sender: :organizer, text: "Hey Alex! Thanks for accepting the booking for Friday's Sunset Session." },
      { sender: :artist,    text: "Hey Sarah! Really excited. What time can I load in my gear and do soundcheck?" },
      { sender: :organizer, text: "Load-in starts at 4:30 PM. We have standard XLR outputs to the house system." },
      { sender: :artist,    text: "Perfect! I will bring my Pioneer controllers and laptop. See you at 4:30!" }
    ]
  },
  {
    organizer: organizers[3], # Marcus Vance (Blue Note)
    artist: artist_users[0],   # Luna & Midnight Grooves
    event: created_events[1],
    messages: [
      { sender: :organizer, text: "Hi Luna, the Blue Note stage is ready for your quartet next Saturday." },
      { sender: :artist,    text: "Wonderful, Marcus! Does the venue provide the grand piano or should we bring keyboards?" },
      { sender: :organizer, text: "We have a freshly tuned Yamaha C7 grand piano right on stage ready for you." },
      { sender: :artist,    text: "That is a dream! Our pianist is going to love it. We will be there at 6:00 PM." }
    ]
  },
  {
    organizer: organizers[1], # Diego Morales (Casa de la Salsa)
    artist: artist_users[6],   # Salsa & Cumbia Kings
    event: created_events[2],
    messages: [
      { sender: :organizer, text: "Andres hermano! We have over 250 tickets sold for the Fiesta de Salsa!" },
      { sender: :artist,    text: "Que bueno Diego! We prepared a special 90-minute tribute set of classic Fania hits." },
      { sender: :organizer, text: "The crowd will go crazy! Make sure you bring the extra percussionists." },
      { sender: :artist,    text: "Count on it! Full 6-piece band ready to burn the house down." }
    ]
  },
  {
    organizer: demo_user,     # Damian Reyes (demo user)
    artist: artist_users[3],   # Mateo Santana (Carlos Santana Tribute)
    event: created_events[5],
    messages: [
      { sender: :organizer, text: "Hey Mateo, saw your video for Black Magic Samba, incredible guitar work!" },
      { sender: :artist,    text: "Thanks Damian! Appreciate that a lot. We love playing live shows." },
      { sender: :organizer, text: "Would you be able to play a 2-hour set for our rock showcase?" },
      { sender: :artist,    text: "Definitely. We have a setlist of over 25 classic Latin rock songs ready." }
    ]
  }
]

chat_conversations.each do |conv|
  room_name = "#{conv[:event].title}: #{conv[:organizer].first_name} & #{conv[:artist].first_name}"
  chatroom = Chatroom.create!(name: room_name)
  ChatUser.create!(user: conv[:organizer], chatroom: chatroom)
  ChatUser.create!(user: conv[:artist], chatroom: chatroom)

  conv[:messages].each do |msg|
    sender_user = msg[:sender] == :organizer ? conv[:organizer] : conv[:artist]
    Message.create!(
      chatroom: chatroom,
      user: sender_user,
      content: msg[:text]
    )
  end
end

puts "❤️ Creating Followers & Favorites for realistic stats..."
# Demo user follows several artists
[0, 1, 2, 3, 4, 6].each do |idx|
  demo_user.follow(artist_users[idx])
end

# Cross-following between artists & organizers
artist_users.each_with_index do |artist, i|
  rand(3..8).times do
    follower = (organizers + artist_users).sample
    follower.follow(artist) unless follower == artist
  end
end

# Demo user favorites some events and musicians
demo_user.favorite(created_events[0])
demo_user.favorite(created_events[1])
demo_user.favorite(created_events[2])
demo_user.favorite(dashboards[0])
demo_user.favorite(dashboards[1])
demo_user.favorite(dashboards[3])

puts "✨ SEEDING COMPLETE! ✨"
puts "📊 Total Users: #{User.count}"
puts "📊 Total Artists: #{Dashboard.count}"
puts "📊 Total Events: #{Event.count}"
puts "📊 Total Bookings: #{Booking.count}"
puts "📊 Total Chatrooms: #{Chatroom.count}"
puts "📊 Total Messages: #{Message.count}"
puts "📊 Total Follows: #{Follow.count}"
puts "📊 Total Favorites: #{Favorite.count}"

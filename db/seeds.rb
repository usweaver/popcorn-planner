require 'open-uri'
require "json"

puts "Reset de la DB"

MovieComment.destroy_all
Vote.destroy_all
MovieEvent.destroy_all
Event.destroy_all
Movie.destroy_all
Member.destroy_all
User.destroy_all
Group.destroy_all

puts "Création des Users"

users = [
  {
    first_name: "Clément", last_name: "Thorez", username: "ClementTHZ", email: "ct@gmail.com", address: "Place Jean Macé", zipcode: "69007", city: "Lyon", encrypted_password: "123456", profile_picture: "ClementTHZ"},
{
    first_name: "Alexandre", last_name: "Valentin", username: "AlexandreVlt", email: "av@gmail.com", address: "22, Rue des Capucins", zipcode: "69001", city: "Lyon", encrypted_password: "123456", profile_picture: "AlexandreVlt"},
  {
    first_name: "Florian", last_name: "Chapuis", username: "FlorianCHPS", email: "fc@gmail.com", address: "79, Rue Hippolyte Kahn", zipcode: "69100", city: "Villeurbanne", encrypted_password: "123456", profile_picture: "usweaver"},
  {
    first_name: "Rémy", last_name: "Cassagne", username: "remycsssg", email: "rc@gmail.com", address: "Place Bellecour", zipcode: "69002", city: "Lyon", encrypted_password: "123456", profile_picture: "remyShift"},
  {
    first_name: "Johnny", last_name: "Jeep", username: "JohnnyJPP", email: "jj@gmail.com", address: "Place Saint-Jean", zipcode: "69005", city: "Lyon", encrypted_password: "123456", profile_picture: "puts-HIROSIE"},
  {
    first_name: "Albert", last_name: "Tho", username: "Alberttho", email: "at@gmail.com", address: "19, Rue de la Platière", zipcode: "69001", city: "Lyon", encrypted_password: "123456", profile_picture: "Samsam69004"},
  {
    first_name: "Thon", last_name: "Mayo", username: "ThonMayo", email: "tm@gmail.com", address: "2, Rue des Tables Claudiennes", zipcode: "69001", city: "Lyon", encrypted_password: "123456", profile_picture: "Wael-Dev52"},
  {
    first_name: "Pedro", last_name: "Pascal", username: "Pedropsc", email: "pp@gmail.com", address: "3, Rue du Président Carnot", zipcode: "69002", city: "Lyon", encrypted_password: "123456", profile_picture: "Pereiraadri"},
  {
    first_name: "Sandy", last_name: "Million", username: "SandiMl", email: "sm@gmail.com", address: "43, Boulevard des Belges", zipcode: "69006", city: "Lyon", encrypted_password: "123456", profile_picture: "juliavitu"},
  {
    first_name: "Sarah", last_name: "Croche", username: "SarahCrh", email: "sc@gmail.com", address: "4, Place Victor Basch", zipcode: "69003", city: "Lyon", encrypted_password: "123456", profile_picture: "Aurelie-bouchon"},
  {
    first_name: "Pella", last_name: "Tarte", username: "PellaTrt", email: "pt@gmail.com", address: "13, Rue Felix Mangini", zipcode: "69009", city: "Lyon", encrypted_password: "123456", profile_picture: "lea3738"
  }
]


users.each do |user|
  file = URI.parse("https://github.com/#{user[:profile_picture]}.png").open
  new_user = User.new(
    first_name: user[:first_name],
    last_name: user[:last_name],
    username: user[:username],
    email: user[:email],
    address: user[:address],
    zipcode: user[:zipcode],
    city: user[:city],
    password: user[:encrypted_password]
  )
  new_user.profile_picture.attach(io: file, filename: "#{user[:profile_picture]}.png", content_type: "image/png")
  new_user.save!
end

puts "#{User.all.count} Users créés"

puts "Création des Groups"

file = URI.parse("https://69latrik.fr/cdn/shop/files/69_500x.png").open
group_one = Group.new(name: "Les potos du 69")
group_one.group_picture.attach(io:file, filename: "les_potos_du_69.png", content_type: "image/png")
group_one.save!

group_one_users = User.all
group_one_users.each do |user|
  Member.create!(group_id: group_one.id, user_id: user.id)
end

file = URI.parse("https://media.cdnws.com/_i/48378/9611/927/12/melange-de-graines-pour-salade-detail.png").open
group_two = Group.new(name: "Les graines")
group_two.group_picture.attach(io:file, filename: "les_graines.png", content_type: "image/png")
group_two.save!

group_two_users = ["Thorez", "Valentin", "Chapuis"]
group_two_users.each do |last_name|
  user = User.where(last_name: last_name)[0]
  Member.create!(group_id: group_two.id, user_id: user.id)
end

file = URI.parse("https://ma-lunch-box.com/cdn/shop/products/petite-glaciere-reps-13-L-orrouge-223796.png").open
group_three = Group.new(name: "Le paquet")
group_three.group_picture.attach(io:file, filename: "le_paquet.png", content_type: "image/png")
group_three.save!

group_three_users = ["Thorez", "Tho", "Mayo", "Pascal"]
group_three_users.each do |last_name|
  user = User.where(last_name: last_name)[0]
  Member.create!(group_id: group_three.id, user_id: user.id)
end

Group.all.each do |group|
  puts "#{group.name} a #{group.users.count} utilisateurs"
end

puts "Création des Events"

events = ["Popcorn & Paillettes", "Ciné-Sieste : On Dort Pas, Promis !", "Clap & Chill", "Projecteur Fou"]
events.each do |event_name|

  user = User.all.sample
  group = user.groups.sample

  event = Event.new(name: event_name, date: Date.today + rand(1..10).days, user: user, group: group)

  event.save!
end

user = User.where(last_name: "Valentin")[0]
group = Group.where(name: "Les graines")[0]
event = Event.new(name: "Best Movies", date: Date.today + rand(1..10).days, user: user, group: group)

event.save!

past_events = ["Action ! Mais Que Pour les Chips", "Le Festival du Canapé", "Ciné-Quizz Party : Lumières, Caméra, Questions !", "Film, Bouffe & Bavardages", "Ciné'Marathon : Survivrez-vous ?", "Les Oscars de la Rigolade"]
past_events.each do |event_name|

  user = User.all.sample
  group = user.groups.sample

  event = Event.new(name: event_name, date: Date.today - rand(10..30).days, user: user, group: group)

  event.save!
end

puts "#{Event.all.count} Events créés"

puts "Création des Movies"

url ="https://api.themoviedb.org/3/movie/now_playing?language=fr-FR&api_key=#{ENV['TMDB_API_KEY']}&page=1"
movie_serialized = URI.parse(url).read
movie_data = JSON.parse(movie_serialized)
results = movie_data["results"]
results.each do |movie|
  movie = Movie.new(name: movie["title"],
            synopsis: movie["overview"],
            poster_url: movie["poster_path"])
  movie.save!
end

movies = [
  {
"original_title": "The Package",
"overview": "Quand quatre ados partent en camping, un accident malheureux les lance dans une course contre la montre pour sauver le trésor le plus précieux de l'un d'eux.",
"poster_path": "/qd2MXsQqxKk9uAB87YmWa3nCM2F.jpg",
"title": "Le paquet",
},
{
"original_title": "Grave",
"overview": "Dans la famille de Justine tout le monde est vétérinaire et végétarien. À 16 ans, elle est une adolescente surdouée sur le point d’intégrer l’école véto où sa sœur ainée est également élève. Mais, à peine installés, le bizutage commence pour les premières années. On force Justine à manger de la viande crue. C’est la première fois de sa vie. Les conséquences ne se font pas attendre. Justine découvre sa vraie nature.",
"poster_path": "/rezrNBKn6xFTOy5uz0zKV2QQD62.jpg",
"title": "Grave",
},
{
"original_title": "Brice de Nice",
"overview": "Éternel ado de presque 30 ans, délaissé par un père affairiste et une mère absente, Brice s'est réfugié dans une posture, un « style » avec lesquels il exprime son vrai vécu intrinsèque : Brice est surfeur, winner... comme Bodhi, le héros de POINT BREAK, son film culte, Brice attend donc SA vague... à Nice ! Personne pourtant ne se risque à se moquer de Brice : redoutable bretteur du langage, Brice s'est fait une spécialité de « casser » tout et tout le monde par le truchement de ses reparties verbales. Il fallait bien qu'un jour Brice soit rattrapé par la réalité...",
"poster_path": "/d8qjZwmXYFseqsXnS7eOSmmgwB9.jpg",
"title": "Brice de Nice",
},
{
"original_title": "White Chicks",
"overview": "Les ambitieux mais malheureux agents du FBI Marcus et Kevin Copeland sont sur le point de perdre leur travail. Quand on découvre que deux riches héritières mondaines sont sur le point d'être enlevées, l'affaire est confiée à leurs rivaux et Kevin et Marcus sont promus gardes du corps pour escorter ces deux gamines de l'aéroport à leur hôtel dans les Hamptons. Malheureusement, leur gentil toutou cause un accident de la circulation. S'ensuit une bagarre et les deux sœurs se retrouvent légèrement mal en point. Elles refusent d'être vues lors de ce week-end mondain. Apeuré à l'idée de se retrouver au chômage, Kevin va élaborer un plan : Marcus et lui vont se faire passer pour les deux exigeantes divas, se mêler à la crème de la crème des Hamptons et, par la même occasion, piéger les ravisseurs et redorer leur réputation.",
"poster_path": "/PedA5zKb8Y3nZEHPGx9LwGlfPx.jpg",
"title": "F.B.I. Fausses Blondes Infiltrées",
}
]
movies.each do |movie|
  movie = Movie.new(name: movie["title"],
            synopsis: movie["overview"],
            poster_url: movie["poster_path"])
  movie.save!
end

puts "#{Movie.all.count} Movies créées"

movie_events = [
  { event: 0, movie: 1, selected_movie: false },
  { event: 0, movie: 2, selected_movie: false },
  { event: 0, movie: 3, selected_movie: false },
  { event: 1, movie: 4, selected_movie: false },
  { event: 1, movie: 5, selected_movie: false },
  { event: 1, movie: 6, selected_movie: false },
  { event: 1, movie: 7, selected_movie: false },
  { event: 2, movie: 8, selected_movie: false },
  { event: 2, movie: 9, selected_movie: false },
  { event: 2, movie: 10, selected_movie: false },
  { event: 2, movie: 11, selected_movie: false },
  { event: 3, movie: 12, selected_movie: false },
  { event: 3, movie: 13, selected_movie: false },
  { event: 3, movie: 14, selected_movie: true },
  { event: 3, movie: 5, selected_movie: false },
  { event: 3, movie: 9, selected_movie: false },
  { event: 4, movie: 20, selected_movie: false },
  { event: 4, movie: 21, selected_movie: false },
  { event: 4, movie: 22, selected_movie: false },
  { event: 4, movie: 23, selected_movie: false }
]

movie_events.each do |e|
  event = Event.all[e[:event]]
  movie = Movie.all[e[:movie]]
  movie_event = MovieEvent.create!(event: event, movie: movie, selected_movie: e[:selected_movie])
  if e[:selected_movie]
    user = User.where(last_name: "Thorez")[0]
    Vote.create!(user_id: user.id, movie_event_id: movie_event.id)
  end
end

past_movie_events = [
  { event: 5, movie: 14, selected_movie: true },
  { event: 6, movie: 15, selected_movie: true },
  { event: 7, movie: 16, selected_movie: true },
  { event: 8, movie: 17, selected_movie: true },
  { event: 9, movie: 18, selected_movie: true },
  { event: 10, movie: 19, selected_movie: true }
]

past_movie_events.each do |e|
  event = Event.all[e[:event]]
  group = event.group
  group_users = group.users
  movie = Movie.all[e[:movie]]
  movie_event = MovieEvent.create!(event_id: event.id, movie_id: movie.id, selected_movie: e[:selected_movie])
  users = group_users.sample(3)
  MovieComment.create!(user_id: users[0].id, comment: "Trop cool! J'ai grave kiffé 😍", rating: 9, movie_event_id: movie_event.id)
  MovieComment.create!(user_id: users[1].id, comment: "C'est bien de la merde! 💩", rating: 2, movie_event_id: movie_event.id)
  MovieComment.create!(user_id: users[2].id, comment: "Ca passe 🫡", rating: 5, movie_event_id: movie_event.id)
  Vote.create!(user_id: users[0].id, movie_event_id: movie_event.id)
  Vote.create!(user_id: users[1].id, movie_event_id: movie_event.id)
  Vote.create!(user_id: users[2].id, movie_event_id: movie_event.id)
end

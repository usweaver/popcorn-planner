require 'open-uri'
require "json"

puts "Reset de la DB !"

Member.destroy_all
Event.destroy_all
MovieEvent.destroy_all
Movie.destroy_all
User.destroy_all
Group.destroy_all

puts "Création des Users !"

users = [
{
    first_name: "Alexandre", last_name: "Valentin", username: "AlexandreVlt", email: "av@gmail.com", address: "22 rue des Capucins", zipcode: "69001", city: "Lyon", encrypted_password: "123456"},
  {
    first_name: "Florian", last_name: "Chapuis", username: "FlorianCHPS", email: "fc@gmail.com", address: "79, rue Hippolyte Kahn", zipcode: "69100", city: "Lyon", encrypted_password: "123456"},
  {
    first_name: "Rémy", last_name: "Cassagne", username: "remycsssg", email: "rc@gmail.com", address: "Place Bellecour", zipcode: "69002", city: "Lyon", encrypted_password: "123456"
  },
  {
    first_name: "Clément", last_name: "Thorez", username: "ClementTHZ", email: "ct@gmail.com", address: "Place Jean Macé", zipcode: "69007", city: "Lyon", encrypted_password: "123456"},
  {
    first_name: "Johnny", last_name: "Jeep", username: "JohnnyJPP", email: "jj@gmail.com", address: "Place Saint-Jean", zipcode: "69005", city: "Lyon", encrypted_password: "123456"},
  {
    first_name: "Albert", last_name: "Tho", username: "Alberttho", email: "at@gmail.com", address: "19 rue de la Platière", zipcode: "69001", city: "Lyon", encrypted_password: "123456"},
  {
    first_name: "Thon", last_name: "Mayo", username: "ThonMayon", email: "tm@gmail.com", address: "2 rue des tables claudiennes", zipcode: "69001", city: "Lyon", encrypted_password: "123456"},
  {
    first_name: "Pedro", last_name: "Pascal", username: "Pedropsc", email: "pp@gmail.com", address: "3 rue du président Carnot", zipcode: "69002", city: "Lyon", encrypted_password: "123456"},
  {
    first_name: "Sandy", last_name: "Million", username: "SandiMl", email: "sm@gmail.com", address: "43 boulevard des Belges", zipcode: "69006", city: "Lyon", encrypted_password: "123456"},
  {
    first_name: "Sarah", last_name: "Croche", username: "SarahCrh", email: "sc@gmail.com", address: "4 places Victor Basch", zipcode: "69003", city: "Lyon", encrypted_password: "123456"},
  {
    first_name: "Pella", last_name: "Tarte", username: "PellaTrt", email: "pt@gmail.com", address: "13 rue Felix Mangini", zipcode: "69009", city: "Lyon", encrypted_password: "123456"}]

photos = ["remyShift", "Samsam69004", "usweaver", "lea3738", "Wael-Dev52", "Pereiraadri", "puts-HIROSIE", "Aurelie-bouchon", "ClementTHZ", "AlexandreVlt", "juliavitu"]

users.each do |user|
  user_image = photos.sample
  file = URI.parse("https://github.com/#{user_image}.png").open
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
  new_user.profile_picture.attach(io: file, filename: "#{user_image}.png", content_type: "image/png")
  new_user.save!
  photos.delete(user_image)
end
puts "#{User.all.count} utilisateurs crées"

puts "Création des groupes avec des utilisateurs !"

groups = ["Les potos du 69", "Les graines", "Le paquet"]
photos2 = ["remyShift", "Samsam69004", "usweaver", "lea3738", "Wael-Dev52", "Pereiraadri", "puts-HIROSIE", "Aurelie-bouchon", "ClementTHZ", "AlexandreVlt", "juliavitu"]

groups.each do |group|
  group_image = photos2.sample
  file = URI.parse("https://github.com/#{group_image}.png").open
  new_group = Group.new(name: group)
  new_group.group_picture.attach(io:file, filename: "#{group}.png", content_type: "image/png")
  new_group.save!

  group_users = User.all.sample(rand(2..11))
  group_users.each do |user|
    Member.create!(group_id: new_group.id, user_id: user.id)
  end
end

Group.all.each do |group|
  puts "#{group.name} a #{group.users.count} utilisateurs"
end

left_users = User.where.missing(:members)
if left_users.any?
  leftovers_group = Group.create(name: "les oubliés")
  left_users.each do |user|
    Member.create!(group: leftovers_group, user: user)
  end
end

puts "Création des événements"

events = ["Popcorn & Paillettes", "Ciné-Sieste : On Dort Pas, Promis !", "Clap & Chill", "Projecteur Fou", "Les Oscars de la Rigolade", "Film, Bouffe & Bavardages", "Ciné'Marathon : Survivrez-vous ?", "Action ! Mais Que Pour les Chips", "Le Festival du Canapé", "Ciné-Quizz Party : Lumières, Caméra, Questions !"]
events.each do |event_name|

  user = User.all.sample
  group = user.groups.sample

  event = Event.new(name: event_name, date: Date.today, user: user, group: group)

  event.save!
end

puts "Parsing de l'API"

url ="https://api.themoviedb.org/3/movie/now_playing?language=fr-FR&api_key=#{ENV['TMDB_API_KEY']}&page=1"
movie_serialized = URI.parse(url).read
movie_data = JSON.parse(movie_serialized)
results = movie_data["results"]
results.each do |movie|
  movie = Movie.new(name: movie["original_title"],
            synopsis: movie["overview"],
            poster_url: movie["poster_path"])
  movie.save!
end

puts "ajout des films aux évènements"

Event.all.each do |event|
  movies = Movie.all
  movies.each do |movie|
    MovieEvent.create!(event: event, movie: movie)
  end
  puts "#{event.name} crée par #{event.user.first_name} pour #{event.group.name} - #{event.movies.count} films proposés"
end

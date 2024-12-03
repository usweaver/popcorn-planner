users = []

10.times do |i|
  users << { email: "#{i}@test.fr", encrypted_password: "password"}
end
p "ok"
User.insert_all(users)

movies = []

10.times do |i|
  movies << {
    name: "Film #{i}",
    synopsis: "Description films",
    poster_url: "https://google.fr"
  }
end

Movie.insert_all(movies)

group = Group.create(
  name: "Groupe Test",
  )

event = Event.create(
  user: User.first,
  group: group,
  date: Time.now,
  name: "Event seed"
)

5.times do |i|
  event.group.users << User.find(i + 2)
end
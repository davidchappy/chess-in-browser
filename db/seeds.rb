# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# p = Player.create(email: "white@example.com", 
#                   name: "Sample White", 
#                   password: "password", 
#                   password_confirmation: "password")

# p2 = Player.create(email: "black@example.com",
#                   name: "Sample Black",
#                   password: "password", 
#                   password_confirmation: "password")

# g = Game.create(white: p,
#                 black: p2,
#                 status: "saved")

guest = Guest.create(name: "Bob")
guest2 = Guest.create(name: "Jim")
g = Game.start(guest, guest2)
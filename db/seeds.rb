# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  name: "foo",
  email: "foo@example.com",
  password: "foobarbaz",
  password_confirmation: "foobarbaz",
  admin: true,
  activated: true,
  activated_at: Time.zone.now
).create_money_account!(balance: 1000)

99.times do |n|
  name = FFaker::Name.name
  email = "foo-#{n+1}@example.com"
  password = "foobarbaz"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now
  ).create_money_account!(balance: 1000)
end

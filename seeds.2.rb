# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


100.times do 
  Vendor.create ({
    name: Faker::Company.name,
    address: Faker::Address.full_address,
    phone: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.email,
    website: Faker::Internet.domain_name,
    description: Faker::Lorem.paragraph(2),
    content: Faker::Lorem.paragraph(20),
  })
end

10.times do 
  School.create({
    name: Faker::Company.name,
  })
end

Vendor.all.each do |vendor|
  vendor.school = School.all.sample
  vendor.save
end

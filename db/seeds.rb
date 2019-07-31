# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do |t|
	Person.create(name: Faker::Name.name, email: Faker::Internet.email,  role: 'user', password: '123456')
end

10.times do |t|
	Project.create(name: Faker::Games::Pokemon.name, manager: Person.last)
end

Project.all.each do |project|
	5.times do |t|
		history = History.create(name: Faker::Games::Pokemon.move,
			owner: Person.find(rand(1..10)),
			requester: Person.find(rand(1..10)),
			deadline: Date.current - rand(10).days,
			points: [1, 2, 3, 5, 8, 13][rand(6)],
			project: project
		)

		3.times do |t|
			Task.create(description: "Task #{t}", history: history)
		end
	end
end
User.transaction do
  User.create!(name:  "Example User",
               email: "example@railstutorial.org",
               password: "foobar",
               password_confirmation: "foobar",
               is_admin: true)

  5.times do |n|
    name  = Faker::Name.name
    email = "example-#{n + 1}@railstutorial.org"
    password = "password"
    User.create!(name:  name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end

  users = User.take(6)
  5.times do
    title = Faker::Lorem.sentence(1)
    content = Faker::Lorem.paragraph
    users.each {|user| user.reviews.create!(title:title, content: content)}
  end
end

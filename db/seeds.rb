User.transaction do
  User.create!(name:  "Example User",
               email: "example@railstutorial.org",
               password: "foobar",
               password_confirmation: "foobar",
               confirmation_token: "aaa",
               confirmed_at: Time.now,
               confirmation_sent_at: Time.now,
               admin: true)

  5.times do |n|
    name  = Faker::Name.name
    email = "example-#{n + 1}@railstutorial.org"
    password = "password"
    User.create!(name:  name,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 confirmed_at: Time.now)
  end

  users = User.take(6)
  5.times do
    title = "Travel to " + Faker::Lorem.sentence(1)
    content = Faker::Lorem.paragraph
    users.each {|user| user.reviews.create!(title:title, content: content)}
  end
end

1.times do
  Hastag.create!(title: "homestay")
  Hastag.create!(title: "resort")
  Hastag.create!(title: "vietnam")
  Hastag.create!(title: "english")
  Hastag.create!(title: "tour")
  Hastag.create!(title: "travel")
end

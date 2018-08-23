FactoryBot.define do
  factory :trip do
    name {"Example"}
    place {Place.new(name: "HN")}
    owner {FactoryBot.create(:user)}
  end
end

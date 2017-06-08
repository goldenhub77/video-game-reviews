FactoryGirl.define do

  factory :video_game do
    sequence(:title) { |n|  "#{Faker::Team.name}#{n}" }
    developer { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    platform_ids { [Random.rand(1..Platform.all.count).to_s] }
    genre_id { Random.rand(1..Genre.all.count).to_s }
    release_date { Date.parse('2016-05-20') }
    rating { Random.rand(0..5) }
  end
end

FactoryGirl.define do
  factory :time_punch do
    entry { Faker::Time.between(DateTime.now - 1, DateTime.now) }
    clockedInStatus true
    workday
  end
end

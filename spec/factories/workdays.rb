FactoryGirl.define do
  factory :workday do
    user
    hoursWorked 8.0
    dayDate { Faker::Date.backward(1) }
    notes { Faker::Lorem.sentence }
  end
end

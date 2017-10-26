FactoryGirl.define do
  factory :department do
    sequence(:name) { Faker::Company.name }
    sequence(:phone_number) { "+1760555#{Faker::PhoneNumber.unique.subscriber_number}" }
  end
end

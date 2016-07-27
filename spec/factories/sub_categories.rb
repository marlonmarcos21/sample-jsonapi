FactoryGirl.define do
  factory :sub_category do
    name     { Faker::Commerce.department(1, true) }
    category { FactoryGirl.create(:category) }
  end
end

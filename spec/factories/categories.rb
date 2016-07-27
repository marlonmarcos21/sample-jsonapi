FactoryGirl.define do
  factory :category do
    name { Faker::Commerce.department(1, true) }

    factory :category_with_sub_category do
      after :create do |category|
        FactoryGirl.create(:sub_category, category: category)
      end
    end
  end
end

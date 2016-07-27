FactoryGirl.define do
  factory :product do
    name        { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph(1) }
    tnc         { Faker::Lorem.paragraph }
    price       { Faker::Commerce.price }
    stock       { rand(100) + 5 }
    sold_count  { stock - rand(5) }
    categories  { [FactoryGirl.create(:category)] }

    factory :active_product do
      active true
    end
  end
end

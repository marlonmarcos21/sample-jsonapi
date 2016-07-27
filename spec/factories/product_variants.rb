FactoryGirl.define do
  factory :product_variant do
    name       { Faker::Commerce.product_name }
    price      { Faker::Commerce.price }
    stock      { rand(100) + 5 }
    sold_count { stock - rand(5) }
    product    { FactoryGirl.create(:product) }
  end
end

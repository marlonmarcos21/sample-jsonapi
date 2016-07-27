FactoryGirl.define do
  factory :user_profile do
    first_name 'Stanley'
    last_name  'Smith'
    user { FactoryGirl.create(:user) }    
  end
end

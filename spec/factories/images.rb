FactoryGirl.define do
  factory :image do
    source_file_name    { 'test.jpg' }
    source_content_type { 'image/jpeg' }
    source_file_size    { 1024 }
    source_updated_at   { Time.zone.now }
    attachable          { FactoryGirl.create(:product) }
  end
end

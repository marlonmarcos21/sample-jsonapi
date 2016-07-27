# t.string  :name
# t.integer :weight, default: 0
# t.boolean :active, default: :true

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'Associations & Validations' do
    it { is_expected.to have_many(:sub_categories) }
    it { is_expected.to have_and_belong_to_many(:products) }
    it { is_expected.to validate_presence_of(:name) }
  end
end

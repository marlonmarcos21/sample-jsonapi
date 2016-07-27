# t.string     :name
# t.integer    :weight,  default: 0
# t.boolean    :active,  default: :true
# t.references :category

require 'rails_helper'

RSpec.describe SubCategory, type: :model do
  describe 'Associations & Validations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_and_belong_to_many(:products) }
    it { is_expected.to validate_presence_of(:name) }
  end
end

# t.string     :name
# t.decimal    :price
# t.boolean    :active,    default: true
# t.integer    :stock
# t.integer    :sold_count
# t.references :product
# t.integer    :weight,    default: 0

require 'rails_helper'

RSpec.describe ProductOption, type: :model do
  describe 'Associations & Validations' do
    it { is_expected.to belong_to :product }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :price }
    it { is_expected.to validate_presence_of :product }
  end
end

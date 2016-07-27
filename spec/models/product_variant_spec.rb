# t.string     :name
# t.decimal    :price
# t.boolean    :active,         default: true
# t.integer    :stock
# t.integer    :sold_count
# t.references :product
# t.references :product_option
# t.integer    :weight,         default: 0

require 'rails_helper'

RSpec.describe ProductVariant, type: :model do
  describe 'Associations & Validations' do
    it { is_expected.to belong_to :product }
    it { is_expected.to belong_to :product_option }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :price }
    it { is_expected.to validate_presence_of :product }
  end
end

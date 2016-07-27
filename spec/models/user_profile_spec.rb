# t.string     :first_name
# t.string     :last_name
# t.date       :date_of_birth
# t.string     :street_address1
# t.string     :street_address2
# t.string     :city
# t.string     :state
# t.string     :postal_code
# t.string     :phone_number
# t.string     :mobile_number
# t.references :user

require 'rails_helper'

RSpec.describe UserProfile, type: :model do
  describe 'Associations & Validations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to validate_presence_of :user }
  end
end

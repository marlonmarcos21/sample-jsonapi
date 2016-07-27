# t.string   :email
# t.string   :encrypted_password
# t.string   :reset_password_token
# t.datetime :reset_password_sent_at
# t.datetime :remember_created_at
# t.integer  :sign_in_count,         default: 0
# t.datetime :current_sign_in_at
# t.datetime :last_sign_in_at
# t.inet     :current_sign_in_ip
# t.inet     :last_sign_in_ip
# t.string   :token
# t.boolean  :active,                default: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations & Validations' do
    it { is_expected.to have_one :user_profile }
  end

  describe 'Callbacks' do
    let(:user) { FactoryGirl.create(:user) }

    subject { user.save }

    describe '#set_token' do
      context 'when password was not changed' do
        it 'does not change the token' do
          expect { subject }.not_to change { user.token }
        end
      end

      context 'when password was changed' do
        before do
          @old_token = user.token
          user.password = 'abc123def456'
          user.password_confirmation = 'abc123def456'
        end

        it 'changes the token' do
          expect { subject }.to change { user.token }.from(@old_token)
        end
      end
    end
  end
end

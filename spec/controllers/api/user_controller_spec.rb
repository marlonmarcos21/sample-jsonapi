require 'rails_helper'

describe Api::UserController, type: :controller do
  include_context 'managing_json_api_resources'

  let(:existing_user)  { FactoryGirl.create(:user_with_profile) }
  let(:new_user)       { FactoryGirl.build(:user) }
  let(:resource_klass) { Api::UserResource }

  describe "'GET' show" do
    subject { get :show }

    context 'when not logged in' do
      it 'returns unauthorized error' do
        subject
        expect(data['errors'].first['title']).to eql('Invalid authorization')
      end
    end

    context 'when logged in' do
      before do
        authenticate_user existing_user
      end

      it 'returns the current logged in user' do
        subject
        expect(data['data']['id']).to eql(existing_user.id.to_s)
      end
    end
  end

  describe "'POST' create" do
    before do
      @data = prepare_json_api_request_body(new_user,
                                            resource_klass,
                                            with_relationship: false)[:data]
    end

    subject { post :create, data: @data }

    context 'failed request' do
      it 'does not create the user without password' do
        subject
        expect(data['errors']).not_to be_empty
      end
    end

    context 'succesful request' do
      before do
        @data['attributes']['password'] = '123123123'
        @data['attributes']['password-confirmation'] = '123123123'
      end

      it 'creates the new user' do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'creates the user profile' do
        expect { subject }.to change(UserProfile, :count).by(1)
        expect(UserProfile.last.user_id).to eql(data['data']['id'].to_i)
      end
    end
  end

  describe "'PATCH' update" do
    let(:other_user)   { FactoryGirl.create(:user) }
    let(:user_profile) { existing_user.user_profile }

    before do
      authenticate_user existing_user
      @data = prepare_json_api_request_body(existing_user,
                                            resource_klass,
                                            with_relationship: false)[:data]
    end

    subject { patch :update, data: @data }

    describe 'updating profile' do
      before do
        @data['attributes']['first-name'] = 'Gwapo'
        @data['attributes']['last-name']  = 'Ako'
      end

      it 'allows updating user_profile attributes' do
        subject
        user_profile.reload
        expect(user_profile.first_name).to eql('Gwapo')
        expect(user_profile.last_name).to eql('Ako')
      end

      describe 'when updating not own user' do
        before do
          authenticate_user other_user
        end

        it 'returns an error' do
          subject
          expect(data['errors']).not_to be_empty
        end
      end
    end

    describe 'changing password' do
      before do
        @data['attributes']['password'] = 'maraxotka'
        @data['attributes']['password-confirmation'] = 'maraxotka'
      end

      context 'failed request' do
        before do
          @data['attributes']['old-password'] = 'wrongpassword'
        end

        it 'does not change the password if old-password is incorrrect' do
          subject
          expect(data['errors']).not_to be_empty
        end
      end

      context 'succesful request' do
        before do
          @old_token = existing_user.token
          @data['attributes']['old-password'] = '123123123'
        end

        it 'changes the user token' do
          expect { subject }.to change { existing_user.reload.token }.from(@old_token)
        end
      end
    end
  end
end

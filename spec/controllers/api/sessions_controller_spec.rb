require 'rails_helper'

describe Api::SessionsController, type: :controller do
  let(:data) { JSON.parse(response.body) }
  let(:user) { FactoryGirl.create(:user) }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "POST 'create'" do
    let(:login_params) do
      { user: { email: user.email, password: '123123123' }, format: :json }
    end

    subject do
      post :create, login_params
    end

    describe 'successful login' do
      it 'returns the user details' do
        subject
        expect(data['token']).to eql(user.token)
        expect(data['email']).to eql(user.email)
        expect(data['user_id']).to eql(user.id)
      end

      it 'increments sign_in_count' do
        expect { subject }.to change { user.reload.sign_in_count }.by(1)
      end
    end

    describe 'failed logins' do
      it 'renders 401 if password is incorrect' do
        login_params[:user][:password] = 'wrongpassword'
        subject
        expect(response.status).to eql(401)
      end

      it 'renders 401 if user is inactive' do
        user.deactivate!
        subject
        expect(response.status).to eql(401)
      end
    end
  end
end

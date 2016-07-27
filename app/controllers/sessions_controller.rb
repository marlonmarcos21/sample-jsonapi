class SessionsController < Devise::SessionsController
  def create
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    render json: { errors: [title: 'Invalid authorization'] }, status: 401
  end
end

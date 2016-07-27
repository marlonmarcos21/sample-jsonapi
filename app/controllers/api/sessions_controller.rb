class Api::SessionsController < SessionsController
  def create
    self.resource = warden.authenticate!(auth_options.merge(scope: :user, store: false))
    if resource.active?
      set_flash_message(:notice, :signed_in) if is_flashing_format?
      sign_in(resource)

      yield resource if block_given?

      data = { token:   resource.token,
               email:   resource.email,
               user_id: resource.id     }

      render json: data, status: 201
    else
      super
    end
  end
end

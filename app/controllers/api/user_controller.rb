class Api::UserController < Api::ApiController
  before_action :authenticate_from_token!, except: :create
  before_action :inject_id,                except: :create

  prepend_before_action :remove_attributes, only: [:create, :update]

  private

  def inject_id
    params[:id] = @current_user.id.to_s
  end

  def remove_attributes
    params[:data][:attributes].delete 'active'
  end
end

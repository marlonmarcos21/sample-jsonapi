class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  skip_after_action :warn_about_not_setting_whodunnit

  attr_reader :current_user

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :handle_exception
  end

  def four_zero_four
    render_json_api_error 'No API found for this path and method', 404
  end

  protected

  def authenticate_from_token!(options = {})
    unauthorized unless verify_http_token(options)
  end

  def check_http_token
    verify_http_token(render_immediately: false)
  end

  def verify_http_token(options = {})
    options.reverse_merge!(render_immediately: true, inject_user: true)

    authenticate_with_http_token do |token, opts|
      email = opts[:email].presence
      user  = email && User.actives.find_by_email(email)

      if user && Devise.secure_compare(user.token, token)
        @current_user = user
        return true unless options[:inject_user]
        inject_context(:current_user, current_user)
      elsif options[:render_immediately]
        unauthorized
      end
    end
  end

  def resource_not_found
    render_json_api_error 'Resource not found', 404
  end

  def unauthorized
    render_json_api_error 'Invalid authorization', 401
  end

  def render_json_api_error(message, status_code)
    render json: { errors: [title: message] },
           status: status_code
  end

  private

  def handle_exception(exception = nil)
    return unless exception
    resource_not_found if exception.class == ActiveRecord::RecordNotFound
    four_zero_four     if [ActionController::RoutingError,
                           ActionController::UnknownController].include?(exception.class)
  end
end

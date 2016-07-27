module JsonApiResourceController
  extend ActiveSupport::Concern

  included do
    before_action :inject_params_to_context
  end

  private

  def handle_required_params(param_name)
    raise JSONAPI::Exceptions::ParameterMissing.new(param_name) unless params[param_name]
  end

  def handle_resource_not_found(key = :id)
    raise JSONAPI::Exceptions::RecordNotFound.new(key)
  end

  def context
    @context ||= {}
  end

  def inject_params_to_context
    inject_context :params, params
  end

  def inject_context(key, value)
    context[key] = value
  end
end

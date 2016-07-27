shared_context 'managing_json_api_resources' do
  let(:data) { JSON.parse(response.body) }

  before do
    request.env['CONTENT_TYPE'] = 'application/vnd.api+json'
  end
end

def authenticate_user(user = FactoryGirl.create(:user))
  request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token
                                        .encode_credentials(user.token, email: user.email)
end

def prepare_json_api_request_body(model, resource_klass, options = {})
  options.reverse_merge!(with_relationship: true, context: {})
  params  = serialized_resource(model, resource_klass, options[:context])
  params[:data].delete('links')
  params[:data].delete('id') if params[:data]['id'].nil?

  return params if !options[:with_relationship] &&
                     params[:data]['relationships'].nil?

  if options[:with_relationship].is_a?(Hash)
    params[:data]['relationships'] = options[:with_relationship]
  elsif !options[:with_relationship] && !params[:data]['relationships'].nil?
    params[:data].delete 'relationships'
  elsif !params[:data]['relationships'].nil?
    strip_links(params[:data]['relationships'], model)
  end

  params
end

def serialized_resource(model, resource_klass, resource_context = {})
  resource  = resource_klass.new model, resource_context
  JSONAPI::ResourceSerializer
    .new(resource_klass)
    .serialize_to_hash(resource)
end

def strip_links(relationships, model)
  nil_associations = relationships.select do |association_name, association_hash|
    model_id = model.try(association_name).try(:id)
    unless model_id.nil?
      relationships[association_name].delete(:links)
      association_data = relationships[association_name]['data']
      if association_data.nil?
        relationships[association_name]['data'] = {
          type: association_name.pluralize,
          id:   model_id
        }
      end
    end

    model_id.nil?
  end.keys

  nil_associations.each do |association_name|
    relationships.delete(association_name)
  end
end

def relationship_object_for(model, association_name = nil, type = nil)
  if model.try(:is_a?, Array)
    type = model.first.class.name.underscore.dasherize unless type
    data = model.map do |m|
      { type: type.pluralize, id: m.id }
    end
  else
    type = model.class.name.underscore.dasherize unless type
    data = { type: type.pluralize, id: model.id }
  end

  association_name ||= type
  Hash[association_name => Hash[data: data]]
end

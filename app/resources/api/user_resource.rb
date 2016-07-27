class Api::UserResource < JSONAPI::Resource
  attributes :email, :active, :first_name, :last_name
  attributes :date_of_birth, :street_address1, :street_address2
  attributes :city, :state, :postal_code, :phone_number, :mobile_number
  attributes :password, :password_confirmation, :old_password

  before_create :build_profile
  before_update :validate_password_change

  class << self
    def fields
      super - %i(password password_confirmation old_password)
    end
  end

  private

  def build_profile
    UserProfile.new(user: @model)
  end

  def validate_password_change
    attributes = context[:params]['data']['attributes']
    if attributes['password'] && attributes['password-confirmation']
      old_password = attributes['old-password']
      unless @model.valid_password?(old_password)
        @model.errors.add :old_password, 'old password is invalid'
        raise JSONAPI::Exceptions::ValidationErrors.new(self)
      end
    end
  end
end

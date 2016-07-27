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

class User < ActiveRecord::Base
  has_one :user_profile

  before_save :set_token, if: :encrypted_password_changed?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :actives, -> { where(active: true) }

  delegate :first_name,      to: :user_profile, allow_nil: true
  delegate :last_name,       to: :user_profile, allow_nil: true
  delegate :date_of_birth,   to: :user_profile, allow_nil: true
  delegate :street_address1, to: :user_profile, allow_nil: true
  delegate :street_address2, to: :user_profile, allow_nil: true
  delegate :city,            to: :user_profile, allow_nil: true
  delegate :state,           to: :user_profile, allow_nil: true
  delegate :postal_code,     to: :user_profile, allow_nil: true
  delegate :phone_number,    to: :user_profile, allow_nil: true
  delegate :mobile_number,   to: :user_profile, allow_nil: true

  delegate :first_name=,      to: :user_profile
  delegate :last_name=,       to: :user_profile
  delegate :date_of_birth=,   to: :user_profile
  delegate :street_address1=, to: :user_profile
  delegate :street_address2=, to: :user_profile
  delegate :city=,            to: :user_profile
  delegate :state=,           to: :user_profile
  delegate :postal_code=,     to: :user_profile
  delegate :phone_number=,    to: :user_profile
  delegate :mobile_number=,   to: :user_profile

  accepts_nested_attributes_for :user_profile

  # Overrides devise methods
  def active_for_authentication?
    super && active?
  end

  # Instance methods

  def activate!
    update_attribute :active, true
  end

  def deactivate!
    update_attribute :active, false
  end

  # Needed for password change validation
  def old_password=(string)
  end

  private

  def set_token
    self.token = loop do
      new_token = Devise.friendly_token
      break new_token unless User.where(token: new_token).exists?
    end
  end
end

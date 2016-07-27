# t.attachment :source,
# t.references :attachable, polymorphic: true
# t.boolean    :main_image, default: false

require 'rails_helper'

RSpec.describe Image, type: :model do
  describe 'Associations & Validations' do
    it { is_expected.to belong_to(:attachable) }
    it { is_expected.to validate_presence_of(:attachable) }
    it { is_expected.to have_attached_file(:source) }
    it { is_expected.to validate_attachment_presence(:source) }
    it do
      is_expected.to validate_attachment_content_type(:source)
             .allowing(*%w(image/png image/gif image/jpg image/jpeg))
    end
  end
end

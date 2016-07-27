# t.attachment :source,
# t.references :attachable, polymorphic: true
# t.boolean    :main_image, default: false

class Image < ActiveRecord::Base
  has_attached_file :source, styles: { small:  { geometry: '70x70#',   processors: [:thumbnail] },
                                       medium: { geometry: '110x110#', processors: [:thumbnail] },
                                       large:  { geometry: '180x180#', processors: [:thumbnail] },
                                       xlarge: { geometry: '200x200#', processors: [:thumbnail] } },
                             default_url: "#{ENV['AWS_S3_BUCKET']}/images/:style/missing.jpg",
                             storage: :s3,
                             s3_credentials: "#{Rails.root}/config/s3.yml",
                             s3_protocol: :https

  belongs_to :attachable, polymorphic: true

  validates :attachable, presence: true

  validates_attachment_presence     :source
  validates_attachment_content_type :source, content_type: /\Aimage\/.*\Z/
end

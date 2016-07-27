# t.string   :name
# t.string   :description
# t.text     :tnc
# t.decimal  :price
# t.boolean  :active,       default: false
# t.datetime :published_at
# t.boolean  :finished,     default: false
# t.integer  :stock
# t.integer  :sold_count
# t.string   :slug
# t.integer  :weight,       default: 0

class Product < ActiveRecord::Base
  has_one  :main_image, -> { where(main_image: true) }, class_name: 'Image', as: :attachable

  has_many :product_options,         dependent: :destroy
  has_many :product_variants,        dependent: :destroy
  has_many :images, as: :attachable, dependent: :destroy

  has_and_belongs_to_many :categories,    join_table: :products_categories
  has_and_belongs_to_many :sub_categories

  validates :name,       presence: true
  validates :tnc,        presence: true
  validates :price,      presence: true
  validates :categories, presence: true

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_paper_trail on: :update

  include PgSearch
  pg_search_scope :search,
                  against: :name,
                  using:   { tsearch: { prefix: true, tsvector_column: 'tsv_name' },
                             trigram: { threshold: 0.2 } },
                  order_within_rank: 'products.weight DESC, products.sold_count DESC'

  scope :actives,      -> { where(active: true) }
  scope :not_finished, -> { where(finished: false) }

  class << self
    def in_categories(*category_ids)
      joins(:categories)
        .where(categories: { id: category_ids } )
    end

    def in_sub_categories(*sub_category_ids)
      joins(:sub_categories)
        .where(sub_categories: { id: sub_category_ids } )
    end
  end

  # Instance methods

  def activate!
    update_attribute :active, true
  end

  def deactivate!
    update_attribute :active, false
  end

  private

  def should_generate_new_friendly_id?
    return if active? && !slug.blank?
    slug.blank? || name_changed?
  end
end

class Api::ProductResource < JSONAPI::Resource
  attributes :name, :description, :tnc, :price, :active
  attributes :stock, :sold_count, :slug, :weight

  filters :search, :categories, :sub_categories

  has_one :main_image, class_name: 'Image', foreign_key_on: :related

  has_many :images
  has_many :categories
  has_many :sub_categories

  class << self
    def records(_options = {})
      _model_class.actives.not_finished
    end

    def verify_key(key, _context = nil)
      return key if key.nil?
      return Integer(key) if key.is_a?(Fixnum)

      raise JSONAPI::Exceptions::InvalidFieldValue.new(:id, key) unless key.is_a?(String)
      return key if key.to_s =~ /\A([a-z0-9]+([-_][a-z0-9]+)*)\Z/i

      raise JSONAPI::Exceptions::InvalidFieldValue.new(:id, key)
    rescue
      raise JSONAPI::Exceptions::InvalidFieldValue.new(:id, key)
    end

    def find_by_key(key, options = {})
      context = options[:context]
      records = records(options)
      records = apply_includes(records, options)
      begin
        model = records.find(key)
        new(model, context)
      rescue
        raise JSONAPI::Exceptions::RecordNotFound.new(key) if model.nil?
      end
    end

    def apply_filter(records, filter, values, options)
      case filter
      when :search
        search_term = values.first
        return records if search_term.blank?
        records.search(search_term)

      when :categories
        records.in_categories(values)

      when :sub_categories
        records.in_sub_categories(values)

      else
        super(records, filter, values, options)
      end
    end

    def apply_filters(records, filters, options = {})
      if filters.key?(:search) &&
         (filters.key?(:categories) || filters.key?(:sub_categories))
        search_term = filters.delete(:search).first
        records     = records.search(search_term) unless search_term.blank?

        categories = filters.delete(:categories)
        records    = records.in_categories(categories) if categories

        sub_categories = filters.delete(:sub_categories)
        records = records.in_sub_categories(sub_categories) if sub_categories
      end

      super(records, filters, options)
    end
  end
end

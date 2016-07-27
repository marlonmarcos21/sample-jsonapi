module DataSeeder
  class << self
    def categories(count = 5)
      count.times do
        name = loop do
          fake_name = Faker::Commerce.department(2, true)
          break fake_name unless Category.where(name: fake_name).exists?
        end

        Category.create(name: name, weight: rand(5))
      end
    end

    def sub_categories(count = 3)
      Category.actives.find_each do |category|
        count.times do
          name = loop do
            fake_name = Faker::Commerce.department(2, true)
            break fake_name unless Category.where(name: fake_name).exists? || SubCategory.where(name: fake_name).exists?
          end
          category.sub_categories.build(name: name, weight: rand(5))
          category.save
        end
      end
    end

    def products(count = 50, with_options = false, with_variants = false)
      raise 'Please create categories first' if Category.actives.count == 0
      raise 'Please create sub-categories first' if SubCategory.actives.count == 0

      count.times do
        category_offset = rand(Category.count)
        category        = Category.offset(category_offset).first
        subcat_id       = category.sub_categories.pluck(:id).sample
        stock           = rand(100) + 5
        product = Product.create(
          name: Faker::Commerce.product_name,
          description: Faker::Lorem.paragraph(1),
          tnc: Faker::Lorem.paragraph,
          price: Faker::Commerce.price,
          stock: stock,
          sold_count: stock - rand(5),
          active: [true, false].sample,
          finished: [true, false].sample,
          category_ids: category.id,
          sub_category_ids: subcat_id
        )

        if with_options
          3.times do
            product_option = ProductOption.create(
              name: Faker::Commerce.product_name,
              price: Faker::Commerce.price,
              product: product
            )

            if with_variants
              ProductVariant.create(
                name: Faker::Commerce.product_name,
                price: Faker::Commerce.price,
                product: product,
                product_option: product_option
              )
            end
          end
        end
      end
    end
  end
end

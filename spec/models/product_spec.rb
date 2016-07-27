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

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Associations & Validations' do
    it { is_expected.to have_many :product_options }
    it { is_expected.to have_many :product_variants }
    it { is_expected.to have_and_belong_to_many :categories }
    it { is_expected.to have_and_belong_to_many :sub_categories }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :tnc }
    it { is_expected.to validate_presence_of :price }
    it { is_expected.to validate_presence_of :categories }
  end

  describe 'search' do
    before do
      @product1 = FactoryGirl.create(:product, name: 'Apple Iphone')
      @product2 = FactoryGirl.create(:product, name: 'Sony Android')
      @product3 = FactoryGirl.create(:product, name: 'Samsung & Apple Phones')
    end

    subject { Product.search(@term) }

    describe 'searching exact match' do
      before do
        @term = 'Sony Android'
      end

      it 'returns only exact search match' do
        results = subject
        expect(results).to include(@product2)
        expect(results).not_to include(@product1, @product3)
      end
    end

    describe 'searching common matches' do
      before do
        @term = 'apple'
      end

      it 'returns any products containing the search term' do
        results = subject
        expect(results).to include(@product1, @product3)
        expect(results).not_to include(@product2)
      end
    end
  end

  describe 'generating slug' do
    let(:product) { FactoryGirl.build(:product) }

    subject { product.save }

    it 'generates slug after creating' do
      expect { subject }.to change { product.slug }.from(nil)
    end

    context 'when changing product name while already active' do
      before do
        product.active = true
        product.save
        @slug = product.slug
        product.name = 'new name'
      end

      it 'does not change the slug' do
        subject
        expect(product.reload.slug).to eql(@slug)
      end
    end
  end

  describe 'Class methods' do
    let(:category1)     { FactoryGirl.create(:category) }
    let(:category2)     { FactoryGirl.create(:category) }
    let(:category3)     { FactoryGirl.create(:category) }
    let(:sub_category1) { FactoryGirl.create(:sub_category, category: category1) }
    let(:sub_category2) { FactoryGirl.create(:sub_category, category: category2) }
    let(:sub_category3) { FactoryGirl.create(:sub_category, category: category3) }

    let(:product1) do
      FactoryGirl.create(:product, categories: [category1], sub_categories: [sub_category1])
    end
    let(:product2) do
      FactoryGirl.create(:product, categories: [category2], sub_categories: [sub_category2])
    end
    let(:product3) do
      FactoryGirl.create(:product, categories: [category3], sub_categories: [sub_category3])
    end
    let(:product4) do
      FactoryGirl.create(:product,
                         categories: [category1, category3],
                         sub_categories: [sub_category1, sub_category3])
    end

    before do
      product1
      product2
      product3
      product4
    end

    describe '#in_categories' do
      subject { Product.in_categories(category1.id) }

      it 'returns products under the category' do
        results = subject
        expect(results).to include(product1, product4)
        expect(results).not_to include(product2, product3)
      end
    end

    describe '#in_sub_categories' do
      subject { Product.in_sub_categories(sub_category2.id) }

      it 'returns products under the sub category' do
        results = subject
        expect(results).to include(product2)
        expect(results).not_to include(product1, product3, product4)
      end
    end
  end
end

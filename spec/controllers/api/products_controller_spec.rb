require 'rails_helper'

RSpec.shared_examples 'successful request with non empty data' do
  it do
    subject
    expect(data['data']).not_to be_empty
  end
end

describe Api::ProductsController, type: :controller do
  include_context 'managing_json_api_resources'

  let(:category) { FactoryGirl.create(:category_with_sub_category) }
  let(:product) do
    FactoryGirl.create(:active_product,
                       categories: [category],
                       sub_categories: category.sub_categories)
  end

  before do
    product
  end

  describe "'GET' index" do
    subject { get :index }

    it_behaves_like 'successful request with non empty data'

    describe 'filters' do
      subject { get :index, filter: @filter }

      describe 'search' do
        before do
          @filter = { search: product.name }
        end

        it_behaves_like 'successful request with non empty data'
      end

      describe 'categories' do
        before do
          @filter = { categories: product.categories.first.id }
        end

        it_behaves_like 'successful request with non empty data'
      end

      describe 'sub_categories' do
        before do
          @filter = { sub_categories: product.sub_categories.first.id }
        end

        it_behaves_like 'successful request with non empty data'
      end
    end
  end

  describe "'GET' show" do
    subject { get :show, id: product.id }

    it 'returns data successfully' do
      subject
      expect(data['data']).not_to be_empty
    end
  end
end

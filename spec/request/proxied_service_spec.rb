require 'rails_helper'

RSpec.describe 'Proxied Service', type: :request do
  context 'with a proxied service URL' do
    before do
      #stub_request(:get, 'catalogue-service-ap-southeast-1.development.sephora-asia.net')
    end

    it 'properly proxies the service' do
      get '/api/products/23423.json'
      expect(response.body).to include('iPhone')
    end
  end
end
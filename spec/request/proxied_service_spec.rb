require 'rails_helper'

RSpec.describe 'Proxied Service', type: :request do

  def stub_rack_proxy(status_code, status_msg, headers, body)
    streaming_response = Rack::HttpStreamingResponse.new(nil,'test', '443')
    allow(streaming_response).to receive(:headers) { headers }
    allow(streaming_response).to receive(:body) { body }
    http_response = Net::HTTPResponse.new('1.0', status_code, status_msg)
    allow(streaming_response).to receive(:response) {  http_response }
    allow(Rack::HttpStreamingResponse).to receive(:new) do |request, host, port|
      yield(request, host, port)
      streaming_response
    end
  end

  context 'with a proxied service URL' do
    let(:res) {'{"status":"ok"}'}

    it 'properly proxies the service for HTTPS request with non default port' do
      stub_rack_proxy(200, 'OK', { }, res) do |request, host, port|
        expect(request.path).to eq("/23423.json")
        expect(host).to eq("www.apple.com")
        expect(port).to eq(8080)
      end
      get '/api/https-with-port-8080/23423.json'
      expect(response.body).to include(res)
    end

    it 'properly proxies the service for HTTPS request with default port' do
      stub_rack_proxy(200, 'OK', { }, res) do |request, host, port|
        expect(request.path).to eq("/23423.json")
        #expect(request.scheme).to eq('https')
        expect(host).to eq("www.apple.com")
        expect(port).to eq(443)
      end
      get '/api/https-with-no-port/23423.json'
      expect(response.body).to include(res)
    end

    it 'properly proxies the service for HTTP request with non default port' do
      stub_rack_proxy(200, 'OK', { }, res) do |request, host, port|
        expect(request.path).to eq("/23423.json")
        #expect(request.scheme).to eq('https')
        expect(host).to eq("www.apple.com")
        expect(port).to eq(8080)
      end
      get '/api/http-with-port-8080/23423.json'
      expect(response.body).to include(res)
    end


    it 'properly proxies the service for HTTP request with default port' do
      stub_rack_proxy(200, 'OK', { }, res) do |request, host, port|
        expect(request.path).to eq("/23423.json")
        #expect(request.scheme).to eq('https')
        expect(host).to eq("www.apple.com")
        expect(port).to eq(80)
      end
      get '/api/http-with-no-port/23423.json'
      expect(response.body).to include(res)
    end



  end
end
require 'rails_helper'

RSpec.describe 'Proxied Service', type: :request do

  def stub_rack_proxy(status_code, status_msg, headers, body)
    http_response = Net::HTTPResponse.new('1.0', status_code, status_msg)
    streaming_response = Rack::HttpStreamingResponse.new(nil, nil)
    allow(streaming_response).to receive(:headers) { headers }
    allow(streaming_response).to receive(:body) { body }
    allow(streaming_response).to receive(:response) { http_response }
    allow(Rack::HttpStreamingResponse).to receive(:new) do |request, host, port|
      yield(request, host, port)
      streaming_response
    end
  end

  context 'with a proxied service URL' do
    let(:res) { '{"status":"ok"}' }
    let(:cookie) { 'JWT-TOKEN=jwt.token' }
    let(:path) { '/some/path/2/a.json' }

    it 'properly proxies the service for HTTPS request with non default port' do
      stub_rack_proxy(200, 'OK', { }, res) do |request, host, port|
        expect(request.path).to eq(path)
        expect(request['Cookie']).to eq(cookie)
        expect(request.method).to eq('GET')
        expect(host).to eq("www.example.com")
        expect(port).to eq(8080)
      end

      get '/api/https-with-port-8080' + path, headers: {cookie: cookie}
      expect(response.body).to include(res)
    end

    it 'properly proxies the service for HTTPS GET request with default port' do
      stub_rack_proxy(200, 'OK', { }, res) do |request, host, port|
        expect(request.path).to eq(path)
        expect(request.method).to eq('GET')
        expect(host).to eq("www.example.com")
        expect(port).to eq(443)
      end
      get '/api/https-with-no-port' + path
      expect(response.body).to include(res)
    end

    it 'properly proxies the service for HTTP GET request with non default port' do
      stub_rack_proxy(200, 'OK', { }, res) do |request, host, port|
        expect(request.path).to eq(path)
        expect(request.method).to eq('GET')
        expect(host).to eq("www.example.com")
        expect(port).to eq(8080)
      end
      get '/api/http-with-port-8080' + path
      expect(response.body).to include(res)
    end

    it 'properly proxies the service for HTTP GET request with default port and some cookies' do
      stub_rack_proxy(200, 'OK', { }, res) do |request, host, port|
        expect(request.path).to eq(path)
        expect(request.method).to eq('GET')
        expect(request['Cookie']).to eq(cookie)
        expect(host).to eq("www.example.com")
        expect(port).to eq(80)
      end

      get '/api/http-with-no-port' + path, headers: {cookie: cookie}
      expect(response.body).to include(res)
    end

    it 'properly proxies the service for HTTP GET request with default port' do
      stub_rack_proxy(200, 'OK', { }, res) do |request, host, port|
        expect(request.path).to eq(path)
        expect(request.method).to eq('GET')
        expect(host).to eq("www.example.com")
        expect(port).to eq(80)
      end

      get '/api/http-with-no-port' + path
      expect(response.body).to include(res)
    end

    it 'properly proxies the service for HTTPS GET request with default port and no cookies if cookie forwarding is disabled' do
      stub_rack_proxy(200, 'OK', { }, res) do |request, host, port|
        expect(request.path).to eq(path)
        expect(request['Cookie']).to eq('')
        expect(host).to eq("www.example.com")
        expect(port).to eq(443)
      end

      get '/api/https-with-no-cookie-forwarding' + path, headers: {cookie: cookie}
      expect(response.body).to include(res)
    end

    it 'properly proxies the service for HTTPS GET request with params to default port' do
      params = {param1: 'value1', param2: 'value2'}
      stub_rack_proxy(200, 'OK', { }, res) do |request, host, port|
        expect(request.path).to eq(path + "?" + params.to_query)
        expect(request['Cookie']).to eq(cookie)
        expect(host).to eq("www.example.com")
        expect(port).to eq(443)
      end

      get '/api/https-with-get-params' + path, params: params, headers: {cookie: cookie}
      expect(response.body).to include(res)
    end

    it 'properly proxies the service for HTTPS POST request with default port' do
      post_body = 'hello=world'

      stub_rack_proxy(200, 'OK', { }, res) do |request, host, port|
        expect(request.path).to eq(path)
        expect(request.method).to eq('POST')
        expect(request['Cookie']).to eq(cookie)
        expect(request.body_stream.read).to eq(post_body)
        expect(host).to eq("www.example.com")
        expect(port).to eq(443)
      end

      post '/api/https-post-request' + path, params: post_body, headers: {cookie: cookie}
      expect(response.body).to include(res)
    end
  end
end
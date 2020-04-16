module Service
  module Proxy
    class Railtie < ::Rails::Railtie
      initializer 'service.proxy' do |app|
        app.middleware.use Service::Proxy::Middleware
      end
    end
  end
end

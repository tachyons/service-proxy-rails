require 'rack-proxy'

module Service
  module Proxy
    class Middleware < Rack::Proxy
      def initialize(app = nil, opts= {})
        super
      end

      def perform_request(env)
        request = Rack::Request.new(env)

        # use rack proxy for anything hitting our host app at /example_service
        if config && request.path =~ config.proxied_paths_matcher
          service = config.service_matching_path(request.path)
          puts service.backend.inspect
          puts service.backend.scheme
          puts service.backend.host

          # most backends required host set properly, but rack-proxy doesn't set this for you automatically
          # even when a backend host is passed in via the options
          env['SERVER_NAME'] = env['HTTP_HOST'] = service.backend.host

          # This is the only path that needs to be set currently on Rails 5 & greater
          env['PATH_INFO'] = service.backend_path_for(request.path)

          # don't send your sites cookies to target service, unless it is a trusted internal service that can parse all your cookies
          env['HTTP_COOKIE'] = '' unless service.send_cookies?

          env['content-length'] = nil
          super(env)
        else
          @app.call(env)
        end
      end

      def rewrite_response(triplet)
        status, headers, body = triplet
        headers['content-length'] = nil
        triplet
      end

      private

      def config
        return @config if instance_variable_defined?(:'@config')
        if File.exist?(Rails.root.join('config/service_proxy.yml'))
          config_data = Rails.application.config_for(:service_proxy)
          @config = Config.new(config_data) if config_data
        end
        @config ||= nil
      end
    end
  end
end

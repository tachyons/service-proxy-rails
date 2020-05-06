# frozen_string_literal: true

require 'rack-proxy'

module Service
  module Proxy
    class Middleware < Rack::Proxy
      def perform_request(env)
        request = Rack::Request.new(env)

        # use rack proxy for anything hitting our host app at /example_service
        if config && request.path =~ config.proxied_paths_matcher
          service = config.service_matching_path(request.path)

          # most backends required host set properly, but rack-proxy doesn't set this for you automatically
          # even when a backend host is passed in via the options
          env['SERVER_NAME'] = env['HTTP_HOST'] = [service.backend.host, service.backend.port].compact.join(':')
          env['SERVER_PORT'] = service.backend.port.to_s
          env['rack.backend'] = service.backend
          env['rack.url_scheme'] = service.backend.scheme
          env['HTTPS'] = service.backend.scheme.downcase == 'https' ? 'on' : 'off'

          # This is the only path that needs to be set currently on Rails 5 & greater
          env['PATH_INFO'] = service.backend_path_for(request.path)

          # don't send your sites cookies to target service, unless it is a trusted internal service that can parse all your cookies
          env['HTTP_COOKIE'] = '' unless service.send_cookies?

          # other Rack::Proxy opts
          env['rack.ssl_verify_none'] = true unless service.verify_ssl?
          env['http.read_timeout'] = service.read_timeout unless service.read_timeout.nil?

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
          @config = Config.new(config_data.deep_symbolize_keys) if config_data
        end
        @config ||= nil
      end
    end
  end
end

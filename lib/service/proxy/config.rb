module Service
  module Proxy
    class Config
      attr_reader :config

      def initialize(config = {})
        @config = config || {}
      end

      def proxied_paths_matcher
        @proxied_paths_matcher ||= Regexp.union(services.collect(&:path_regexp))
      end

      def service_matching_path(path)
        services.detect { |service| service.path_regexp =~ path }
      end

      def services
        @services ||= config.fetch(:services, {}).map { |k, v| ServiceConfig.new(k, v)  }
      end
    end
  end
end

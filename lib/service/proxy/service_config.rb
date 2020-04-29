module Service
  module Proxy
    class ServiceConfig
      def initialize(name, options)
        @name = name
        @options = options
      end

      def backend
        @backend ||= URI(@options.fetch(:backend, ''))
      end

      def backend_path_for(original_path)
        original_path.delete_prefix!(path)
        [backend.path, original_path].compact.join('/').gsub(/\/+/, '/')
      end

      def path
        @path ||= @options.fetch(:path)
      end

      def path_regexp
        @path_regexp ||= Regexp.new("^#{Regexp.escape(path)}")
      end

      def send_cookies?
        @options.fetch(:forward_cookies, true)
      end

      def verify_ssl?
        @options.fetch(:verify_ssl, true)
      end

      def read_timeout
        @options.fetch(:read_timeout, nil)
      end
    end
  end
end

module Service
  module Proxy
    class ServiceConfig
      def initialize(name, options)
        @name = name
        @options = options
      end

      def backend
        puts "backend"
        puts @options.fetch(:backend, '').inspect
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
        true
      end
    end
  end
end

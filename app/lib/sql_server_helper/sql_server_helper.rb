# frozen_string_literal: true

module SqlServerHelper
  # Use this for cache stores from sand
  class SqlServerConnection
    class << self
      def cache_stores(connection); end

      def connect; end
    end
  end
end

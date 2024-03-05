# typed: strict
# frozen_string_literal: true

module Vigiles
  module Utilities
    module URI
      extend T::Sig

      sig { params(url: String).returns(T.any(::URI::HTTP, ::URI::HTTPS)) }
      def self.parse_into_http_or_https(url)
        parsed_uri = ::URI.parse(url)
        raise unless parsed_uri.is_a?(::URI::HTTP) || parsed_uri.is_a?(::URI::HTTPS)

        parsed_uri
      end
    end
  end
end

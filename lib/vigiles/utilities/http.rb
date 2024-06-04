# typed: strict
# frozen_string_literal: true

module Vigiles
  module Utilities
    module HTTP
      extend T::Sig

      WellKnownHttpHeader = Vigiles::Types::WellKnownHttpHeader
      ContentType         = Vigiles::Types::ContentType

      # if http headers could be stemmed, this is what the
      # method below would have done. at the moment, it works
      # for only a few headers, and tries to clean up excesses
      # that are not necessarily part of the value.
      #
      # since it raises, do not call unless you have explicitly
      # handled the header. thanks!
      sig { params(header: String, value: String).returns(String) }
      def self.sanitize_header_value(header:, value:)
        # don't attempt to sanitize values for relatively unknown
        # headers. for example, custom headers (those with the x
        # prefix). obviously if the value is blank then no sanitization
        # is necessary.
        return value if value.blank? || !well_known?(header)

        case header.downcase
        when "content-type" then sanitize_content_type(value.strip)
        else raise ArgumentError, header
        end
      end

      sig { params(header_value: String).returns(String) }
      private_class_method def self.sanitize_content_type(header_value)
        downcased_v = header_value.downcase
        return ContentType::ApplicationJson.serialize if json?(downcased_v)

        raise
      end

      sig { params(header: String).returns(T::Boolean) }
      private_class_method def self.well_known?(header)
        WellKnownHttpHeader.deserialize(header.downcase)
        true
      rescue StandardError
        false
      end

      sig { params(header_value: String).returns(T::Boolean) }
      private_class_method def self.json?(header_value)
        return false if header_value.blank?

        application_json = T.must(header_value.split(/;/).first)
        T.must(
          Constants::ALL_IANA_CONTENT_TYPES[ContentType::ApplicationJson]
        ).include?(application_json)
      end
    end
  end
end

# typed: strict
# frozen_string_literal: true

require "uri"

module Vigiles
  module Archive
    extend T::Sig

    class Request < T::Struct
      # raised when some request parameters are either bad/invalid
      # or absent. for example, it is required the request url always
      # be present, and have either http or https scheme.
      class InvalidParameterError < StandardError
        sig { returns(String) }
        attr_reader :parameter

        sig { params(parameter: String).void }
        def initialize(parameter)
          @parameter = parameter
          super
        end
      end

      const :content_type, String
      const :http_method,  Types::HttpMethod
      const :user_agent,   String
      const :timestamp,    DateTime
      const :remote_ip,    IPAddr
      const :protocol,     String
      const :headers,      Types::Headers
      const :origin,       String
      const :payload,      Types::Payload
      const :path,         String
      const :url,          T.any(URI::HTTPS, URI::HTTP)
      const :id,           String

      sig { params(header_key: String).returns(String) }
      private_class_method def self.best_effort_unfuck_http_header(header_key)
        (header_key.starts_with?("HTTP_") ? T.must(header_key[5..]) : header_key)
          .split(/_/)
          .map(&:titlecase)
          .join("-")
      end

      sig { params(request: ActionDispatch::Request).returns(Request) }
      def self.from(request)
        preferred_headers = Vigiles.spec.request_headers
        available_headers = request.original_headers
        recorded_headers  = (available_headers if preferred_headers.empty?)
        recorded_headers ||= preferred_headers.to_h { [_1, available_headers[_1]] }
        unfucked_headers = recorded_headers.transform_keys { best_effort_unfuck_http_header _1 }

        Request.new(
          content_type: request.content_type || (raise InvalidParameterError, "content_type"),
          user_agent: request.user_agent || "unknown_user_agent",
          timestamp: DateTime.now,
          remote_ip: IPAddr.new(request.remote_ip),
          protocol: request.protocol,
          headers: unfucked_headers,
          origin: request.origin || "unknown_origin_url",
          payload: Utilities::JSON.parse_benignly(request.body.read),
          http_method: Types::HttpMethod.deserialize(request.method),
          path: request.path,
          url: Utilities::URI.parse_into_http_or_https(request.url),
          id: request.request_id
        )
      end
    end
  end
end

# typed: false
# frozen_string_literal: true

module Vigiles
  module Archive
    class Response < T::Struct
      const :rack_response, Rack::Response
      const :content_type, String
      const :headers,      Types::Headers
      const :payload,      Types::Payload
      const :status,       Integer

      sig { params(rack_response: Rack::Response).returns(Types::Payload) }
      private_class_method def self.extract_payload(rack_response)
        case (body = rack_response.body)
        when Array
          return { body: :empty_no_content } if body.empty?

          { __false_body: :not_empty_handle_later }
        when Rack::BodyProxy
          body_proxy = body
          body_proxy = body_proxy.instance_variable_get(:@body) until body_proxy.is_a?(Array)
          begin
            JSON.parse(body_proxy[0])
          rescue StandardError
            { __false_body: body_proxy[0] }
          end
        else
          { __false_body: :unknown_response_payload_type }
        end
      end

      sig { params(res: Rack::Response).returns(Response) }
      def self.from(res)
        Response.new(
          rack_response: res,
          content_type: res.headers["Content-Type"] || "unknown_content_type",
          headers: res.headers.as_json,
          payload: extract_payload(res),
          status: res.status
        )
      end
    end
  end
end

# typed: strict
# frozen_string_literal: true

module Vigiles
  module Archive
    class Response < T::Struct
      const :rack_response, Rack::Response
      const :content_type, String
      const :headers,      Types::Headers
      const :payload,      Types::Payload
      const :status,       Integer

      class InextricableResponseBodyError < StandardError
        sig { returns(String) }
        attr_reader :response_body_class

        sig { params(response_body_class: String).void }
        def initialize(response_body_class:)
          @response_body_class = response_body_class
          super("failed to extract response body: response_body_class=#{response_body_class}")
        end
      end

      class ResponseBodyTooDeepError < StandardError
        sig { returns(Integer) }
        attr_reader :max_stack_depth

        sig { returns(Integer) }
        attr_reader :stack_depth

        sig { params(stack_depth: Integer, max_stack_depth: Integer).void }
        def initialize(stack_depth, max_stack_depth)
          @max_stack_depth = max_stack_depth
          @stack_depth     = stack_depth

          super()
        end
      end

      sig { params(body: Rack::BodyProxy, stack_depth: Integer).returns(String) }
      private_class_method def self.extract_body_from_rack_body_proxy(body, stack_depth = 1)
        raise ResponseBodyTooDeepError.new(stack_depth, 5) unless stack_depth < 5

        case (inner_body = body.instance_variable_get(:@body))
        when Rack::BodyProxy then extract_body_from_rack_body_proxy(inner_body, stack_depth + 1)
        when Array           then inner_body[0] || "null"
        else                 raise InextricableResponseBodyError.new(inner_body.class.name)
        end
      end

      sig { params(rack_response: Rack::Response).returns(T.nilable(Types::Payload)) }
      private_class_method def self.extract_payload(rack_response)
        case (body = rack_response.body)
        when Array
          return { body: :empty_no_content } if body.empty?

          { __false_body: :not_empty_handle_later }
        when Rack::BodyProxy
          extracted_body = extract_body_from_rack_body_proxy(body)
          begin
            JSON.parse(extracted_body)
          rescue StandardError
            { __false_body: extracted_body }
          end
        else
          { __false_body: :unknown_response_payload_type, body_class: body.class.name }
        end
      end

      sig { params(res: Rack::Response).returns(Response) }
      def self.from(res)
        Response.new(
          rack_response: res,
          content_type: res.headers["Content-Type"] || "unknown_content_type",
          headers: res.headers.as_json,
          payload: extract_payload(res) || {__false_body: :body_may_be_nil},
          status: res.status
        )
      end
    end
  end
end

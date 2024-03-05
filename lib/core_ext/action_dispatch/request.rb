# typed: true
# frozen_string_literal: true

module ActionDispatch
  class Request
    sig { returns(T::Hash[String, T.untyped]) }
    def original_headers
      # prefix content-type and content-length with `HTTP_` too,
      # just for uniformity. apparently the rack specification
      # requires content length and content type headers to not
      # have the `HTTP_` prefix.
      # see https://github.com/rack/rack/blob/main/SPEC.rdoc
      #
      @original_headers ||=
        begin
          original = {
            "HTTP_CONTENT_LENGTH" => get_header("CONTENT_LENGTH"),
            "HTTP_CONTENT_TYPE" => get_header("CONTENT_TYPE")
          }

          each_header do |header, value|
            next unless header.start_with?("HTTP_")

            original[header] = value
          end

          original.freeze
        end
    end
  end
end

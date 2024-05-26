# typed: strict
# frozen_string_literal: true

require "json"

module Vigies
  module Utilities
    module JSON
      sig { params(text: String).returns(T.any(String, Vigiles::Types::UntypedHash)) }
      def self.parse_benignly(text)
        ::JSON.parse(text)
      rescue StandardError
        text
      end
    end
  end
end

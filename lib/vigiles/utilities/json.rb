# typed: strict
# frozen_string_literal: true

require "json"

module Vigiles
  module Utilities
    module JSON
      extend T::Sig

      sig { params(text: String).returns(T.any(String, Vigiles::Types::UntypedHash)) }
      def self.parse_benignly(text)
        ::JSON.parse(text)
      rescue StandardError
        text
      end
    end
  end
end

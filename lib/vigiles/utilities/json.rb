# typed: strict
# frozen_string_literal: true

require "json"

module Vigiles
  module Utilities
    module JSON
      extend T::Sig

      sig { params(text: String).returns(T.untyped) }
      def self.parse_benignly(text)
        ::JSON.parse(text)
      rescue StandardError
        return text unless block_given?
        yield text
      end
    end
  end
end

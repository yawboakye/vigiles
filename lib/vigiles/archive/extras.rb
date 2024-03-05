# typed: strict
# frozen_string_literal: true

module Vigiles
  module Archive
    class Extras < T::Struct
      const :request_env, T::Hash[T.untyped, T.untyped]

      sig { params(request_env: T::Hash[T.untyped, T.untyped]).returns(Extras) }
      def self.from(request_env)
        Extras.new(request_env: request_env)
      end
    end
  end
end

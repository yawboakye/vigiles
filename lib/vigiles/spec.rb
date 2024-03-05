# typed: strict
# frozen_string_literal: true

module Vigiles
  class Spec < T::Struct
    const :request_content_types, T::Set[String]
    const :request_headers,       T::Set[String]
    const :recorders,             T::Hash[String, ConversationRecorder]

    sig { returns(Spec) }
    def self.make_default_spec
      Spec.new(
        request_content_types: Constants::DEFAULT_CONTENT_TYPES,
        request_headers: Set[].freeze,
        recorders: Constants::DEFAULT_CONTENT_TYPE_RECORDERS
      )
    end
  end
end

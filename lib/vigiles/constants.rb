# typed: strict
# frozen_string_literal: true

module Vigiles
  module Constants
    DEFAULT_CONTENT_TYPES = T.let(
      Set.new(
        %w[
          application/json
        ]
      ), T::Set[String]
    )

    DEFAULT_CONTENT_TYPE_RECORDERS = T.let(
      {
        "application/json" => Vigiles::ConversationRecorders::ApplicationJson.instance
      }.freeze,
      T::Hash[String, Vigiles::ConversationRecorder]
    )
  end
end

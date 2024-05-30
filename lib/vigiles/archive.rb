# typed: strict
# frozen_string_literal: true

module Vigiles
  module Archive
    extend T::Sig

    Types       = Vigiles::Types
    ContentType = Types::ContentType

    class UnrecordableRequestError < StandardError
      sig { params(reason: String).void }
      def initialize(reason)
        @reason = reason
        super
      end
    end

    sig { params(req: ActionDispatch::Request, res: Rack::Response).returns(T.nilable(Conversation)) }
    def self.record_conversation(req:, res:)
      content_type = req.content_type
      if (recorder = Vigiles.spec.recorders[content_type]).nil?
        raise \
          UnrecordableRequestError,
          "no recorder configured for content type: #{content_type}"
      end

      recorder.record(req:, res:)
    end
  end
end

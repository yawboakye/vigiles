# typed: strict
# frozen_string_literal: true

module Vigiles
  class ConversationRecorder
    class MisconfiguredRecorderError < StandardError
      sig { returns(String) }
      attr_reader :expected

      sig { returns(String) }
      attr_reader :actual

      sig { params(expected: String, actual: String).void }
      def initialize(expected:, actual:)
        @expected = expected
        @actual = actual
        super
      end
    end

    abstract!

    sig { abstract.params(req: ActionDispatch::Request, res: Rack::Response).returns(Archive::Conversation) }
    def record(req:, res:); end
  end
end

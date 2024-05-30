# typed: strict
# frozen_string_literal: true

module Vigiles
  module ConversationRecorders
    class Unknown < ConversationRecorder
      include Singleton

      sig { override.params(req: ActionDispatch::Request).void }
      def ensure_content_type_matches!(req); end

      sig { override.params(req: ActionDispatch::Request, res: Rack::Response).returns(Archive::Conversation) }
      def record(req:, res:) = Archive::Conversation.new
    end
  end
end

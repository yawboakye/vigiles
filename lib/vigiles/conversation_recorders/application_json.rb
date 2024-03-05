# typed: strict
# frozen_string_literal: true

module Vigiles
  module ConversationRecorders
    class ApplicationJson < ConversationRecorder
      include Singleton

      ConversationRecorder = Vigiles::ConversationRecorder
      ContentType          = Vigiles::Types::ContentType
      Conversation         = Vigiles::Archive::Conversation
      Response             = Vigiles::Archive::Response
      Metadata             = Vigiles::Archive::Metadata
      Request              = Vigiles::Archive::Request
      Extras               = Vigiles::Archive::Extras

      sig { override.params(req: ActionDispatch::Request, res: Rack::Response).returns(Archive::Conversation) }
      def record(req:, res:)
        unless req.content_type == ContentType::ApplicationJson.serialize
          raise ConversationRecorder::MisconfiguredRecorderError.new(
            expected: ContentType::ApplicationJson.serialize,
            actual: req.content_type
          )
        end

        response = Response.from(res)
        request  = Request.from(req)
        Conversation.create!(
          request_content_type: request.content_type,
          request_user_agent: request.user_agent,
          request_timestamp: request.timestamp,
          request_remote_ip: request.remote_ip,
          request_protocol: request.protocol,
          request_headers: request.headers,
          request_origin: request.origin,
          request_payload: request.payload,
          request_method: request.http_method.serialize,
          request_path: request.path,
          request_url: request.url,
          request_id: request.id,
          response_content_type: response.content_type,
          response_headers: response.headers,
          response_payload: response.payload,
          response_status: response.status
        )
      end
    end
  end
end

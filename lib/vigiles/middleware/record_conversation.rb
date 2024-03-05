# typed: strict
# frozen_string_literal: true

require "logger"

module Vigiles
  module Middleware
    class RecordConversation
      sig { returns(Vigiles::Options) }
      attr_reader :options

      delegate \
        :capture_exception,
        :logger,
        to: :options

      sig { params(app: T.untyped, options: Vigiles::Options).void }
      def initialize(app, options=Vigiles::Options.make_default_options)
        @app     = app
        @options = options
      end

      sig { params(env: T::Hash[T.untyped, T.untyped]).returns(T.untyped) }
      def call(env)
        req = ActionDispatch::Request.new(env)
        record_conversation(req) do
          @app.call(req.env)
        end
      end

      sig { params(req: ActionDispatch::Request, blk: T.proc.returns(T.untyped)).returns(T.untyped) }
      private def record_conversation(req, &blk)
        rack_response = blk.call
        begin
          res = Rack::Response[*rack_response]
          convo = Vigiles.maybe_record_conversation(req:, res:)
          logger.info \
            "[vigiles] conversation recorder: " \
            "conversation=#{convo.nil? ? "not_recorded" : convo.id} " \
            "request=#{req.request_id}"
        rescue => e
          capture_exception.call(e)
          logger.warn \
            "[vigiles] conversation recorder error: " \
            "error_message=#{e.message} " \
            "error_class=#{e.class}"
        ensure
          # no matter what happens we shouldn't prevent the rack
          # response from being returned. at this point, the only
          # thing that could throw execution into this branch is
          # an exception when the `capture_exception` proc is
          # invoked.
          rack_response
        end
        rack_response
      end
    end
  end
end

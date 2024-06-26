# typed: strict
# frozen_string_literal: true

module Vigiles
  module Types
    extend T::Sig

    class ContentType < T::Enum
      enums do
        ApplicationJson = new("application/json")
        TextHtml        = new("text/html")
        Unknown         = new
      end
    end

    class HttpMethod < T::Enum
      enums do
        OPTIONS = new("OPTIONS")
        DELETE  = new("DELETE")
        POST    = new("POST")
        HEAD    = new("HEAD")
        GET     = new("GET")
        PUT     = new("PUT")
      end
    end

    class WellKnownHttpHeader < T::Enum
      enums do
        ContentType = new("content-type")
      end
    end

    HtmlPayload = String

    UntypedHash = T.type_alias { T::Hash[T.untyped, T.untyped] }
    JsonPayload = T.type_alias { UntypedHash }
    Payload     = T.type_alias { T.any(JsonPayload, HtmlPayload) }
    Headers     = T.type_alias { T::Hash[String, T.untyped] }

    ContentTypeRecorder = T.type_alias do
      T::Hash[String, T.proc.params(arg0: ActionDispatch::Response).returns(Vigiles::Archive::Conversation)]
    end
  end
end

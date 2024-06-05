# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require "action_dispatch"
require "zeitwerk"

require_relative "core_ext"

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.inflector.inflect(
  "json" => "JSON",
  "http" => "HTTP",
  "uri" => "URI"
)
loader.ignore("#{__dir__}/generators")
loader.ignore("#{__dir__}/core_ext.rb")
loader.ignore("#{__dir__}/core_ext")
loader.setup

module Vigiles
  extend T::Sig

  sig { returns(Vigiles::Spec) }
  def self.spec
    @spec ||= T.let(
      Vigiles::Spec.make_default_spec,
      T.nilable(Vigiles::Spec)
    )
  end

  sig { params(spec: Vigiles::Spec).returns(Vigiles::Spec) }
  def self.spec=(spec)
    @spec = spec
  end

  sig { params(req: ActionDispatch::Request, res: Rack::Response).returns(T.nilable(Archive::Conversation)) }
  def self.maybe_record_conversation(req:, res:)
    return unless should_record?(req)

    Archive.record_conversation(req:, res:)
  rescue Archive::UnrecordableRequestError
    nil
  end

  sig { params(blk: T.untyped).void }
  def self.configure(&blk)
    blk.call(spec)

    # TODO(yaw, 2024-06-15): ensure that the spec is valid.
    # ensure that for every content type a recorder is configured. otherwise
    # assign the general recorder for unknown content types.
  end

  sig { params(request: ActionDispatch::Request).returns(T::Boolean) }
  private_class_method def self.content_type_match?(request)
    spec.request_content_types.include?(
      Utilities::HTTP.sanitize_header_value(
        header: "content-type",
        value: request.content_type
      )
    )
  end

  sig { params(req: ActionDispatch::Request).returns(T::Boolean) }
  private_class_method def self.should_record?(req)
    content_type_match?(req)
  end
end

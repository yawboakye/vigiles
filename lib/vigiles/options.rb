# typed: strict
# frozen_string_literal: true

require "logger"
require "rails"

module Vigiles
  class Options < T::Struct
    const :capture_exception, T.proc.params(a0: StandardError).void
    const :logger,            ::Logger

    sig { returns(Options) }
    def self.make_default_options
      Options.new(
        logger: T.unsafe(Rails).logger, # you should be using this within rails.
        capture_exception: ->(e) { e }  # a no-op exception capturer.
      )
    end
  end
end

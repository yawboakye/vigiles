# typed: false
# frozen_string_literal: true

require_relative "initializer_generator"

module Vigiles
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      SUB_GENERATORS = Set.new(
        %w[
          vigiles:initializer
          vigiles:migration
        ]
      ).freeze

      source_root File.expand_path("templates", __dir__)

      def install_vigiles
        SUB_GENERATORS.each do |generator_task|
          invoke generator_task
        end
      end
    end
  end
end

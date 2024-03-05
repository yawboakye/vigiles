# typed: false
# frozen_string_literal: true

module Vigiles
  module Generators
    class InitializerGenerator < ::Rails::Generators::Base
      desc <<~DOC.squish
        This generator creates the vigiles initializer file at the
        `config/initializers/vigiles.rb` path and sets up a sane
        default configuration.
      DOC

      source_root File.expand_path("../templates", __dir__)

      def copy_initializer_file
        copy_file \
          "initializer.rb",
          "config/initializers/vigiles.rb"
      end
    end
  end
end

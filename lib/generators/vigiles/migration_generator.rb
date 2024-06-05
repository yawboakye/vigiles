# typed: false
# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"
require "active_record"

module Vigiles
  module Generators
    class MigrationGenerator < ::Rails::Generators::Base
      desc <<~DOC.squish
      DOC

      include ::Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      def install
        migration_template(
          "archive_conversation_migration.rb.erb",
          "db/migrate/create_vigiles_archive_conversations_table.rb",
          migration_version:
        )
      end

      def migration_version = "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"

      def self.next_migration_number(dirname)
        ActiveRecord::Generators::Base.next_migration_number(dirname)
      end
    end
  end
end

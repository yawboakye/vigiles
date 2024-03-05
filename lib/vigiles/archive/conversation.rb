# typed: strict
# frozen_string_literal: true

require "active_record"

module Vigiles
  module Archive
    class Conversation < ::ActiveRecord::Base
      self.table_name = "vigiles_archive_conversations"
    end
  end
end

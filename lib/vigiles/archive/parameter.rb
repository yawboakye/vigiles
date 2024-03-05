# typed: strict
# frozen_string_literal: true

module Vigiles
  module Archive
    class Parameter < T::Struct
      class Visibility < T::Enum
        enums do
          PersonallyIdentifiableInformation = new("personally_identifiable_information")
          AuthorizationKey = new("authorization_key")
          Password = new("password")
        end
      end

      class Source < T::Enum
        enums do
          Internal = new("internal")
          External = new("external")
        end
      end

      const :visibility, Visibility
      const :encrypted,  T::Boolean
      const :source,     Source
      const :name,       String
    end
  end
end

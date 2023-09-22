module Resorcery
  module Search
    class Input < ApplicationComponent
      attr_reader :form, :attribute, :data_type, :label

      # TODO: Handle all data types, enums, and associations
      def initialize(form, attribute, as: nil, label: nil)
        super
        @form = form
        @attribute = attribute
        @label = label || attribute.to_s.humanize
        @data_type = as || :string
      end
    end
  end
end

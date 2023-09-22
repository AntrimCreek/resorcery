module Resorcery
  module Show
    class Attributes < ApplicationComponent
      attr_reader :resource, :model, :attributes

      def initialize(resource, *attributes)
        super
        set_resource resource
        @attributes = attributes.presence&.map(&:to_s) || model.attribute_names
      end
    end
  end
end

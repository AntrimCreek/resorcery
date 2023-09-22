module Resorcery
  module Header
    class Breadcrumb < ApplicationComponent
      attr_reader :resource, :model

      def initialize(resource: nil)
        super
        set_resource(resource)
      end
    end
  end
end

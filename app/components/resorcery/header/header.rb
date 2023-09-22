module Resorcery
  module Header
    class Header < ApplicationComponent
      attr_reader :resource

      def initialize(resource: nil)
        super
        set_resource(resource)
      end
    end
  end
end

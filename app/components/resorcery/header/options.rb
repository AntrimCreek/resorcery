module Resorcery
  module Header
    class Options < ApplicationComponent
      def initialize(resource: nil)
        super
        set_resource(resource)
      end
    end
  end
end

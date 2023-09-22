module Resorcery
  module Header
    class BreadcrumbItem < ApplicationComponent
      attr_reader :label, :link, :active

      def initialize(label, link: nil, active: false)
        super
        @label = label
        @link = link
        @active = active
      end
    end
  end
end

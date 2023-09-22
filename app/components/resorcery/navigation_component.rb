# frozen_string_literal: true

module Resorcery
  class NavigationComponent < ApplicationComponent
    attr_reader :nav_items

    def initialize(nav_items)
      super
      @nav_items = Resorcery::NavItem.items(*nav_items)
    end
  end
end

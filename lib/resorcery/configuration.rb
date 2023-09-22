require "resorcery/nav_item"

module Resorcery
  class Configuration
    attr_accessor :theme, :app_name
    attr_reader :nav_items

    def initialize
      @app_name = Rails.application.class.module_parent_name
      @theme = :default
      @nav_items = []
    end

    def nav_items=(nav_items)
      @nav_items = Resorcery::NavItem.items(*nav_items)
    end
  end
end

# frozen_string_literal: true

module Resorcery
  class NavItemComponent < ApplicationComponent
    attr_reader :label, :icon, :path, :active

    def initialize(section, label: nil, icon: nil, path: nil, active: false)
      super
      section = section.to_s
      @label = label || section.titleize
      @icon = icon
      @path = path || [section.to_sym]
      @active = active
    end
  end
end

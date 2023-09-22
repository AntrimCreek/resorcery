# frozen_string_literal: true

module Resorcery
  class NavItem
    attr_reader :model, :controller, :label, :path, :icon

    def initialize(resource = nil, model: nil, controller: nil, label: nil, path: nil, icon: nil)
      resource = resource&.to_s

      @model = model || resource&.singularize&.camelize&.safe_constantize
      raise Error, "NavItem model cannot be blank" unless @model.nil? || @model.ancestors.include?(ActiveRecord::Base)

      @path = path || "/#{@model&.model_name&.route_key || resource.underscore}"

      @controller = controller
      @controller ||= "#{@model.model_name.plural.camelize}Controller".safe_constantize if @model
      @controller ||= "#{resource.camelize}Controller".safe_constantize
      raise Error, "NavItem controller is not a valid controller" if @controller.present? && !@controller.ancestors.include?(ActionController::Base)

      @label = label || @model&.model_name&.plural&.titleize || resource.titleize
      raise Error, "NavItem label cannot be blank" if @label.blank?

      @icon = icon
    end

    # Allow a wide range of formats, including:
    # items(:home, :users, :posts)
    # items([:home, { label: "Dashboard", icon: "house" }], :users, :posts)
    # items({ label: "Home", path: '/' }, { label: 'Users', path: [:users] }, { label: 'Posts', path: [:posts] })
    def self.items(*components)
      components.map do |component|
        if component.is_a?(String) || component.is_a?(Symbol)
          NavItem.new(component)
        elsif component.is_a?(Array)
          NavItem.new(component[0], **(component[1] || {}))
        elsif component.is_a?(Hash)
          NavItem.new(**component.symbolize_keys)
        elsif component.is_a?(NavItem) || component.nil?
          component
        else
          raise Error "Cannot create NavItem from #{component.inspect}"
        end
      end.flatten
    end
  end
end

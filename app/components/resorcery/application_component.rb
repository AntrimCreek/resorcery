# frozen_string_literal: true

module Resorcery
  class ApplicationComponent < ViewComponent::Base
    # Controller attributes
    attr_reader :action_name, :controller_name, :controller_path
    # Resource attributes
    attr_reader :resource, :model, :collection

    def before_render
      @action_name = controller.action_name
      @controller_name = controller.controller_name
      @controller_path = controller.controller_path
    end

    # Override ViewComponent::Base#sidecar_files to look for component-specific templates in app/components/resorcery
    def self.sidecar_files(extensions)
      Dir[File.join("app", "components", "#{virtual_path}.*{#{extensions.join(",")}}")].presence || super(extensions)
    end

    protected

    def set_resource(resource)
      @resource = resource
      @collection = nil
      if resource.nil?
        # Generic template (for pages like dashboard, home page, etc.)
        @model = nil
      elsif resource.is_a? ActiveRecord::Base
        @model = resource.class
      elsif resource.is_a? ActiveRecord::Relation
        @model = resource.model
        @collection = resource
      elsif resource < ActiveRecord::Base
        @model = resource
        @collection = @model.none
      elsif resource.is_a? String
        @model = resource.singularize.classify.constantize
        @collection = @model.none
      elsif resource.is_a? Symbol
        @model = resource.to_s.singularize.classify.constantize
        @collection = @model.none
      else
        raise ArgumentError, "Invalid resource: #{resource.inspect}"
      end
    end
  end
end

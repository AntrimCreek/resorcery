module Resorcery
  class ControllerGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    argument :model_names, type: :array, required: true

    def models
      @models ||= model_names.map do |model_name|
        model_name.singularize.classify.constantize
      rescue NameError => e
        log "Error: model #{model_name.singularize.classify} does not exist"
        @model_error = true
      end
    end

    def create_controller
      return if @models.blank? || @model_error

      @models.each do |model|
        @model_name = model.name
        template "controllers/controller.rb.erb", "app/controllers/#{model.name.underscore.pluralize}_controller.rb"
        route "resources :#{model.name.underscore.pluralize}"
      end
    end
  end
end

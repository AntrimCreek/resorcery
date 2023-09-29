module Resorcery
  class ViewsGenerator < Rails::Generators::Base
    source_root File.expand_path("templates/views", __dir__)

    class_option :global, type: :boolean, default: false, desc: "Create global view templates"
    argument :resource_param, required: false

    def validate_arguments
      @global = options[:global]
      if resource_param.blank? && !@global
        raise Rails::Generators::Error, "Resource cannot be blank unless --global is specified.\n\n#{usage}"
      elsif resource_param.present? && @global
        raise Rails::Generators::Error, "Resource must be blank when --global is specified.\n\n#{usage}"
      end
    end

    def set_resource_name
      if @global
        @resource_name = ActiveModel::Name.new(nil, nil, "Resource")
      else
        # Accept resource_param in any recognizable format, e.g. "users", "User", "UsersController", etc.
        resource = resource_param.singularize.classify.constantize
        if resource < ActionController::Base && resource.resorcery?
          @resource_name = resource.resource_model_name
        elsif resource < ActiveRecord::Base
          @resource_name = resource.model_name
        else
          abort "Error: unknown resource #{resource_param}"
        end
      end
    rescue NameError => e
      abort "Error: #{e}"
    end

    def copy_views
      if @global
        template "index.html.erb", "app/views/resorcery/index.html.erb"
        template "show.html.erb", "app/views/resorcery/show.html.erb"
        template "form.html.erb", "app/views/resorcery/form.html.erb"
        template "shared/_flash_messages.html.erb", "app/views/resorcery/shared/_flash_messages.html.erb"
      else
        template "index.html.erb", "app/views/#{@resource_name.route_key}/index.html.erb"
        template "show.html.erb", "app/views/#{@resource_name.route_key}/show.html.erb"
        template "form.html.erb", "app/views/#{@resource_name.route_key}/form.html.erb"
      end
    end

    protected

    def usage
      <<~USAGE
        Usage:
          rails generate resorcery:views RESOURCE_PARAM [options]

        Options:
          [--global]\tCreate global view templates
      USAGE
    end
  end
end

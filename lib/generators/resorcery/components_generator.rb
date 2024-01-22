module Resorcery
  class ComponentsGenerator < Rails::Generators::Base
    source_root File.expand_path("../../../app/components/resorcery", __dir__)

    class_option :classes, type: :boolean, default: false, desc: "Create component classes in addition to views"

    def copy_views
      source_path = source_paths.first
      Dir.glob(File.join(source_path, "**/*.html.erb")).each do |file|
        path = Pathname.new(file).relative_path_from(Pathname.new(source_path))
        copy_file(file, "app/components/resorcery/#{path}")
      end
    end
  end
end

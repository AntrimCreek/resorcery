module Resorcery
  class ViewsGenerator < Rails::Generators::Base
    puts "Test"
    # source_root File.expand_path("templates", __dir__)

    def copy_views
      # directory "resorcery", "app/views/resorcery"
    end
  end
end

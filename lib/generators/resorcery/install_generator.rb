module Resorcery
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def create_initializer
      template "initializer.rb.erb", "config/initializers/resorcery.rb"
    end

    def create_stylesheets
      template "application.scss.erb", "app/assets/stylesheets/resorcery/application.scss"
    end
  end
end

module Resorcery
  class IndexViewGenerator < Rails::Generators::Base
    source_root File.expand_path("templates/views", __dir__)

    argument :route_param, required: true

    def copy_view
      @page_title = route_param.titleize
      template "index.html.erb", "app/views/#{@route_param}/index.html.erb"
    end
  end
end

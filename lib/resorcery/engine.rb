module Resorcery
  class Engine < ::Rails::Engine
    isolate_namespace Resorcery

    initializer "resorcery.assets.precompile" do |app|
      app.config.assets.precompile += %w[resorcery/application.css]
    end
  end
end

module Resorcery
  class Engine < ::Rails::Engine
    isolate_namespace Resorcery

    initializer "resorcery.importmap", before: "importmap" do |app|
      app.config.importmap.paths << Engine.root.join("config/importmap.rb")
    end

    initializer "resorcery.assets.precompile" do |app|
      app.config.assets.precompile += %w[resorcery/application.css]
    end
  end
end

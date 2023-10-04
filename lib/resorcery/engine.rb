module Resorcery
  class Engine < ::Rails::Engine
    isolate_namespace Resorcery

    initializer "resorcery.importmap", before: "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb")
      app.config.importmap.cache_sweepers << root.join("app/assets/javascripts")
    end

    initializer "resorcery.assets" do |app|
      app.config.assets.precompile += %w[resorcery_manifest]
    end
  end
end

module Resorcery
  class Engine < ::Rails::Engine
    isolate_namespace Resorcery

    config.to_prepare do
      ActiveRecord::Base.include Resorcery::Resourceable

      ActionController::Base.include Resorcery::ResourceController
      ActionController::Base.helper Resorcery::ApplicationHelper

      ActionView::Base.include Resorcery::Form::FormHelper
    end

    initializer "resorcery.importmap", before: "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb")
      app.config.importmap.cache_sweepers << root.join("app/assets/javascripts")
    end

    initializer "resorcery.assets" do |app|
      app.config.assets.precompile += %w[resorcery_manifest]
    end
  end
end

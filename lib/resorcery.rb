# frozen_string_literal: true

require "resorcery/version"
require "resorcery/engine"
require "resorcery/resource_controller"
require "resorcery/form/form_builder"
require "resorcery/form/form_helper"
require "resorcery/resourceable"
require "resorcery/configuration"

require "importmap-rails"
require "turbo-rails"

require "bootstrap"
require "view_component"
require "ransack"
require "kaminari"

module Resorcery
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Resorcery::Configuration.new
  end

  def self.setup
    yield configuration
  end

  def self.controllers
    @controllers_loaded ||= !!Dir["#{Rails.root}/app/controllers/**/*.rb"].each { |file| require_dependency file } rescue false
    ActionController::Base.descendants.select(&:resorcery?).sort_by(&:name)
  end

  def self.controller_nav_items
    Resorcery::NavItem.items(*controllers.map { |controller| controller.resource_model_name.route_key })
  end

  class Error < StandardError; end
end

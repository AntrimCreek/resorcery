# frozen_string_literal: true

require "resorcery/version"
require "resorcery/engine"
require "resorcery/resource_controller"
require "resorcery/form/form_builder"
require "resorcery/form/form_helper"
require "resorcery/resourceable"
require "resorcery/configuration"

require "view_component"
require "ransack"
require "kaminari"
# require "simple_form"
# require "simple_form_ransack"

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

  class Error < StandardError; end
end

ActiveSupport.on_load(:active_record) do
  include Resorcery::Resourceable
end

ActiveSupport.on_load(:action_controller) do
  include Resorcery::ResourceController
end

ActiveSupport.on_load(:action_view) do
  include Resorcery::Form::FormHelper
end

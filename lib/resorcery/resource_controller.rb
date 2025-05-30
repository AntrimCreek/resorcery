# frozen_string_literal: true

require "resorcery/resource_controller/class_methods"
require "resorcery/resource_controller/instance_methods"

module Resorcery
  module ResourceController
    extend ActiveSupport::Concern

    included do
      delegate :resorcery?,
               :resource_model,
               :resource_model_name,
               :resource_default_sorts,
               :resource_formats,
               :resource_list_columns,
               :resource_detail_keys,
               :resource_form_fields,
               :resource_search_inputs,
               :resource_search_enabled?,
               to: :class
      before_action :set_resource_if_applicable, if: :resorcery?
      before_action :verify_format, if: :resorcery?
    end
  end
end

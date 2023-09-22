# frozen_string_literal: true

require "resorcery/resource_controller/config"

module Resorcery
  module ResourceController
    module ClassMethods
      attr_reader :resource_config

      delegate :model,
               :model_name,
               :default_sorts,
               :formats,
               :list_columns,
               :detail_keys,
               :form_fields,
               :form_options,
               :search_inputs,
               to: :resource_config, prefix: :resource, allow_nil: true

      def resorcery(model, &block)
        model_class = if model.respond_to?(:ancestors) && model.ancestors.include?(ActiveRecord::Base)
                        model
                      elsif model.is_a?(String)
                        model.singularize.classify.constantize
                      elsif model.is_a?(Symbol)
                        model.to_s.singularize.classify.constantize
                      else
                        raise ArgumentError, "Invalid model: #{model.inspect}"
                      end

        @resource_config = Config.new(model_class)
        @resource_config.builder.instance_eval(&block) if block_given?

        layout "resorcery"

        resource_model.send :include, Resorcery::Resourceable

        include InstanceMethods

        helper_method :resource_model,
                      :resource_default_sorts,
                      :resource_formats,
                      :resource_list_columns,
                      :resource_detail_keys,
                      :resource_form_keys,
                      :resource_form_fields,
                      :resource_search_inputs,
                      :resorcery?,
                      :resource_search_enabled?
      end

      def resorcery? = resource_config&.model.present?
      def resource_search_enabled? = resource_search_inputs.present?
    end
  end
end

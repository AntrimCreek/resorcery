# frozen_string_literal: true

module Resorcery
  module ResourceController
    class Config
      attr_reader :model, :builder, :list_keys, :list_options, :detail_keys, :form_keys, :form_options
      attr_accessor :formats, :default_sorts, :search_inputs

      delegate :model_name, to: :model, allow_nil: true

      def initialize(model)
        @model = model
        @list_keys = []
        @list_options = {}
        @detail_keys = []
        @form_keys = []
        @form_options = {}
        @builder = Builder.new(self)
        builder.instance_eval do
          formats(:html, :turbo_stream)
          list_keys(*default_list_keys)
          detail_keys(*default_detail_keys)
          form_keys(*default_form_keys)
          search_inputs
          default_sorts "id asc"
        end
      end

      def set_list_keys(keys = [])
        raise ArgumentError, "List keys must be an array" unless keys.is_a?(Array)

        @list_columns = nil
        @list_keys = keys.map(&:to_sym)
      end

      def set_list_options(options = {})
        raise ArgumentError, "List options must be a hash" unless options.is_a?(Hash)

        @list_columns = nil
        @list_options = options
      end

      def list_columns
        @list_columns ||= list_keys.map do |key|
          options = list_options[key] || {}
          sort_key = (key == :display_name && model.display_name_key) || key
          sortable = options[:sort_key].present? || model.column_names.include?(sort_key.to_s)
          label = (key == :id && "ID") || (key == :display_name && model.name) || key.to_s.titleize
          link = %i[id display_name].include?(key)
          { key:, sortable:, sort_key:, label:, link: }.deep_merge(options.slice(:key, :sortable, :sort_key, :label, :link))
        end.freeze
      end

      def set_detail_keys(keys = [])
        raise ArgumentError, "Detail keys must be an array" unless keys.is_a?(Array)

        @detail_keys = keys.map(&:to_sym)
      end

      def set_form_keys(keys = [])
        raise ArgumentError, "Form keys must be an array" unless keys.is_a?(Array)

        @form_fields = nil
        @form_keys = keys.map(&:to_sym)
      end

      def set_form_options(options = {})
        raise ArgumentError, "Form options must be a hash" unless options.is_a?(Hash)

        @form_fields = nil
        @form_options = options
      end

      def form_fields
        @form_fields ||= form_keys.map { |key| { key: }.deep_merge(form_options[key] || {}) }.freeze
      end

      class Builder
        attr_reader :config

        delegate :model, to: :config

        def initialize(config) = instance_variable_set("@config", config)

        def formats(*formats)
          config.formats = formats.compact_blank.map(&:to_sym)
        end

        def list_keys(*keys) = config.set_list_keys(keys)
        def list_options(**options) = config.set_list_options(options)

        def detail_keys(*keys) = config.set_detail_keys(keys)

        def form_keys(*keys) = config.set_form_keys(keys)
        def form_options(**options) = config.set_form_options(options)

        def default_sorts(*sorts)
          config.default_sorts = sorts.compact_blank.map(&:to_s)
        end

        def search_inputs(enabled: true, **inputs)
          # TODO: Clean this up to work more like form_keys/form_options
          if !enabled
            config.search_inputs = {}
          elsif inputs.empty?
            # Generate default inputs
            config.search_inputs = (model.ransackable_attributes rescue []).map do |attribute|
              type = model.type_for_attribute(attribute).type
              if attribute == "id"
                { id_eq: { label: "ID" } }
              elsif type == :string
                { "#{attribute}_cont": { label: attribute.to_s.titleize, as: :string } }
              elsif type == :datetime
                { "#{attribute}_gteq": { label: "#{attribute.to_s.titleize} After", as: :date },
                  "#{attribute}_lteq": { label: "#{attribute.to_s.titleize} Before", as: :date } }
              elsif type == :boolean
                { "#{attribute}_eq": { label: attribute.to_s.titleize, as: :boolean } }
              else
                { "#{attribute}_eq": { label: attribute.to_s.titleize } }
              end
            end.reduce({}, :merge)
          else
            config.search_inputs = inputs
          end
        end

        private

        def associations(relationship = nil, *other_relationships)
          # Don't include ActiveStorage associations, we'll handle those separately in resource_attachments
          [relationship, *other_relationships].map { |r| model.reflect_on_all_associations(r) }.flatten.reject do |reflection|
            reflection.polymorphic? || reflection.klass <= ActiveStorage::Attachment || reflection.klass <= ActiveStorage::Blob
          end
        end

        def attachment_keys = model.reflect_on_all_attachments.map(&:name)

        # Attributes that the user would usually want to see the raw value of -- the model's columns, minus foreign keys
        def attr_keys = (model.column_names - associations(:belongs_to).map(&:foreign_key)).map(&:to_sym)

        # Keys for attributes to be displayed in index views - id, display_name, and timestamps
        def default_list_keys = %i[id display_name created_at updated_at] & (model.column_names.map(&:to_sym) + [:display_name])

        # Keys for attributes to be displayed in show views -- all attribute keys plus belongs_to and has_and_belongs_to_many associations
        def default_detail_keys = attr_keys + attachment_keys + associations(:belongs_to, :has_and_belongs_to_many).map(&:name)

        # Keys for attributes to be displayed in new/edit views -- attribute keys minus ID and timestamps, plus attachments and parent/sibling associations
        # TODO: Pull keys from Pundit, CanCanCan, or similar
        def default_form_keys = attr_keys - %i[id created_at updated_at] + associations(:belongs_to, :has_and_belongs_to_many).map(&:name) + attachment_keys
      end
    end
    private_constant :Config
  end
end

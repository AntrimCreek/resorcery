# require "resorcery/form/inputs/boolean"

module Resorcery
  module Form
    class FormBuilder < ActionView::Helpers::FormBuilder
      def input(attribute_name = nil, **options, &block)
        # Treat attribute_name as optional, as long as options include a :key.
        # If attribute_name is omitted, the the options hash will have been assigned to attribute_name instead. Fix that.
        if attribute_name.is_a?(Hash)
          options = attribute_name.dup
          attribute_name = nil
        else
          options = options.dup # Prevent modifying the original hash
        end

        attribute_name ||= options.delete(:key)
        raise ArgumentError, "Missing required argument: attribute_name" if attribute_name.blank?

        options[:error] ||= object.errors[attribute_name].presence&.to_sentence
        options[:input_html] ||= {}

        field_type = options.delete(:as)
        if object.defined_enums.key?(attribute_name.to_s)
          field_type ||= :select
          options[:collection] ||= object.defined_enums[attribute_name.to_s].keys.map { |key| [key.humanize, key] }
        end
        field_type ||= :select if options[:collection]
        field_type ||= :email if attribute_name.to_s =~ /(?:\b|\W|_)email(?:\b|\W|_)/
        field_type ||= :password if attribute_name.to_s =~ /(?:\b|\W|_)password(?:\b|\W|_)/

        field_type ||= object.type_for_attribute(attribute_name.to_s)&.type

        reflection = object.class.reflect_on_association(attribute_name) if field_type.nil?
        case reflection
        when ActiveRecord::Reflection::BelongsToReflection
          field_type = :belongs_to
        when ActiveRecord::Reflection::HasManyReflection, ActiveRecord::Reflection::HasAndBelongsToManyReflection
          field_type = :has_many
        end

        field_type ||= (object.respond_to?("#{attribute_name}_attachment") || object.respond_to?("#{attribute_name}_attachments")).presence && :file

        case field_type
        when :belongs_to
          options[:label] ||= attribute_name.to_s.humanize
          options[:collection] ||= reflection.klass.all.map { |record| [record.to_s, record.id] }
          attribute_name = "#{attribute_name}_id"
        when :has_many
          options[:label] ||= attribute_name.to_s.humanize
          options[:collection] ||= reflection.klass.all.map { |record| [record.to_s, record.id] }
          attribute_name = "#{attribute_name.to_s.singularize}_ids"
        end
        component_for_field_type(field_type).new(self, attribute_name, **options).render_in(@template, &block)
      end

      def button(title = nil, **options, &block)
        Inputs::Button.new(self, title, **options).render_in(@template, &block)
      end

      def error_notification(message = nil, &block)
        message ||= "Please review the problems below:" if object.errors.any?
        ErrorNotification.new(message).render_in(@template, &block)
      end

      private

      def component_for_field_type(field_type)
        case field_type
        when :boolean
          Inputs::Boolean
        when :string
          Inputs::String
        when :email
          Inputs::Email
        when :password
          Inputs::Password
        when :select, :belongs_to
          Inputs::Select
        when :has_many, :has_and_belongs_to_many
          Inputs::Multiselect
        when :date, :datetime, :time
          Inputs::Date
        when :integer, :float, :decimal
          Inputs::Number
        when :text
          Inputs::Text
        when :file
          Inputs::File
        when nil
          Inputs::String
        else
          raise "Unknown field type: #{field_type}"
        end
      end
    end
  end
end

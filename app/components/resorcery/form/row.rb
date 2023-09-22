# frozen_string_literal: true

module Resorcery
  module Form
    class Row < ApplicationComponent
      attr_reader :form, :attribute, :label, :association, :args

      def initialize(form, attribute, label: nil, association: false, **args)
        super
        @form = form
        @attribute = attribute
        @label = label || attribute.to_s.titleize
        @association = association
        @args = args
        if association || args[:collection].present?
          @args[:input_html] ||= {}
          @args[:input_html][:class] = "#{@args[:input_html][:class]} form-select"
        elsif form.object.type_for_attribute(attribute).type == :datetime
          @args[:input_html] ||= {}
          @args[:input_html][:class] = "#{@args[:input_html][:class]} form-control w-auto"
        elsif form.object.type_for_attribute(attribute).is_a? ActiveRecord::Enum::EnumType
          @args[:input_html] ||= {}
          @args[:input_html][:class] = "#{@args[:input_html][:class]} form-select"
          @args[:collection] = form.object.class.send(attribute.to_s.pluralize).keys.map { |key| [key.titleize, key] }
          @args[:include_blank] = false
        end
      end
    end
  end
end

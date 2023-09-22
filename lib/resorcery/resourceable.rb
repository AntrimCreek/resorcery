# frozen_string_literal: true

module Resorcery
  module Resourceable
    extend ActiveSupport::Concern

    included do
      extend ClassMethods
      include InstanceMethods
    end

    module ClassMethods
      attr_writer :display_name_key

      def display_name_key
        @display_name_key ||= (column_names & %w[display_name name title]).first&.to_sym
      end
    end

    module InstanceMethods
      def model
        self.class
      end

      def display_name
        self[:display_name] ||
          (self.class.display_name_key && try(self.class.display_name_key).presence) ||
          try(:name).presence ||
          try(:title).presence ||
          new_record? && "New #{model_name.singular.titleize}" ||
          "#{model_name.singular.titleize} #{id}"
      end

      def to_s
        display_name
      end

      def resource_fields
        self.class.resource_field_names.map { |attribute| [attribute, send(attribute)] }.to_h
      end
    end
  end
end

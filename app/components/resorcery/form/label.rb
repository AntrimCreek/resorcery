module Resorcery
  module Form
    class Label < ApplicationComponent
      delegate :default_options, to: :class
      attr_reader :form, :attribute, :text, :options, :for_id

      def initialize(form, attribute, text = nil, **options)
        super
        @form = form
        @attribute = attribute
        @text = text || attribute.to_s.humanize unless text == false
        @options = options.with_indifferent_access
        @for_id = options.delete(:for)
      end

      def self.default_options
        {
          class: "form-label"
        }.with_indifferent_access
      end

      def merge_default_options
        @options = default_options.deep_merge(options) { |_key, v1, v2| "#{v1} #{v2}".strip }
      end
    end
  end
end

module Resorcery
  module Form
    module Inputs
      class BaseInput < ViewComponent::Base
        delegate :html_default_options, :html_error_options, to: :class
        attr_reader :form, :attribute, :options, :html_options

        def initialize(form, attribute, overwrite_options: false, **options)
          super
          @form = form
          @attribute = attribute
          @options = options.slice!(:input_html, :wrapper_html, :label_html, :hint_html, :error_html).with_indifferent_access
          @html_options = options.with_indifferent_access
          merge_html_default_options unless overwrite_options
          merge_html_error_options if error?
        end

        def label = options[:label]
        def hint = options[:hint]
        def error = options[:error]
        def error? = error.present?

        def input_html = html_options[:input_html] || {}
        def wrapper_html = html_options[:wrapper_html] || {}
        def label_html = html_options[:label_html] || {}
        def hint_html = html_options[:hint_html] || {}
        def error_html = html_options[:error_html] || {}

        def self.html_default_options
          {
            input_html: { class: "form-control", placeholder: " " },
            wrapper_html: { class: "form-floating mb-3" },
            label_html: { class: "form-label" },
            hint_html: { class: "form-text" },
            error_html: { class: "invalid-feedback" }
          }.with_indifferent_access
        end

        def self.html_error_options
          {
            input_html: { class: "is-invalid" }
          }.with_indifferent_access
        end

        def merge_html_default_options
          @html_options = html_default_options.deep_merge(html_options) { |_key, v1, v2| "#{v1} #{v2}".strip }
        end

        def merge_html_error_options
          @html_options = html_options.deep_merge(html_error_options) { |_key, v1, v2| "#{v1} #{v2}".strip }
        end
      end
    end
  end
end

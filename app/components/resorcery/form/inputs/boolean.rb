module Resorcery
  module Form
    module Inputs
      class Boolean < BaseInput
        attr_reader :checked_value, :unchecked_value

        def initialize(form, attribute, checked_value: "1", unchecked_value: "0", **options)
          super(form, attribute, **options)
          @checked_value = checked_value
          @unchecked_value = unchecked_value
        end

        def self.html_default_options
          super.deep_merge({
                             input_html: { class: "form-check-input" },
                             label_html: { class: "form-check-label" }
                           })
        end
      end
    end
  end
end

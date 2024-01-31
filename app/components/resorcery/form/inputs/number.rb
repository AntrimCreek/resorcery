module Resorcery
  module Form
    module Inputs
      class Number < BaseInput
        def initialize(form, attribute, **options)
          unless options.dig(:input_html, :step).present?
            options[:input_html] ||= {}
            options[:input_html][:step] = 10.0**-(form.object.class.columns_hash[attribute.to_s].try(:scale) || 0)
          end
          super(form, attribute, **options)
        end
      end
    end
  end
end

module Resorcery
  module Form
    module Inputs
      class Select < BaseInput
        attr_reader :collection

        def initialize(form, attribute, collection: [], **options)
          super(form, attribute, **options)
          @collection = collection
          if options[:include_blank] == true
            @collection.unshift(["", ""])
          elsif options[:include_blank].present?
            @collection.unshift([options[:include_blank].to_s, ""])
          end
        end

        def self.html_default_options
          super.deep_merge({ input_html: { class: "form-select" } })
        end
      end
    end
  end
end

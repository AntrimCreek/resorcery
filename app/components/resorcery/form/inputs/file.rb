module Resorcery
  module Form
    module Inputs
      class File < BaseInput
        def self.html_default_options
          super.deep_merge({ input_html: { placeholder: nil }, wrapper_html: { class: "mb-3" } })
        end
      end
    end
  end
end

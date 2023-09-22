module Resorcery
  module Form
    module Inputs
      class Date < BaseInput
        def input_html
          super.merge({ type: "date" })
        end
      end
    end
  end
end

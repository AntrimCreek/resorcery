module Resorcery
  module Form
    module Inputs
      class Text < BaseInput
        def input_html
          super.merge({ rows: "3" })
        end
      end
    end
  end
end

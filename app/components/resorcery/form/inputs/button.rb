module Resorcery
  module Form
    module Inputs
      class Button < ViewComponent::Base
        delegate :default_options, to: :class
        attr_reader :form, :title, :options

        def initialize(form, title = nil, overwrite_options: false, **options)
          super
          @form = form
          @title = title
          @options = default_options.deep_merge(options) { |_key, v1, v2| "#{v1} #{v2}".strip }
        end

        def self.default_options
          { class: "btn btn-primary", name: nil }.with_indifferent_access
        end
      end
    end
  end
end

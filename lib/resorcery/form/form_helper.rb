module Resorcery
  module Form
    module FormHelper
      def resource_form_for(resource, options = {}, &block)
        options[:builder] ||= Resorcery::Form::FormBuilder
        options[:html] ||= { class: "mb-3" }

        # Bypass Rails' default field error proc to allow for custom error handling
        default_field_error_proc = ::ActionView::Base.field_error_proc
        begin
          ::ActionView::Base.field_error_proc = proc { |html_tag| html_tag }
          form_for(resource, options, &block)
        ensure
          ::ActionView::Base.field_error_proc = default_field_error_proc
        end
      end
    end
  end
end

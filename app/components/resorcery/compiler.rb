module Resorcery
  class Compiler < ViewComponent::Compiler
    def templates
      @templates ||=
        begin
          extensions = ActionView::Template.template_handler_extensions

          component_class.sidecar_files(extensions).each_with_object([]) do |path, memo|
            pieces = File.basename(path).split(".")
            memo << {
              path:,
              variant: pieces[1..-2].join(".").split("+").second&.to_sym,
              handler: pieces.last
            }
          end
        end
    end
  end
end

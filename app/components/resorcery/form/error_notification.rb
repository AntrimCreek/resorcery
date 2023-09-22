module Resorcery
  module Form
    class ErrorNotification < ApplicationComponent
      attr_reader :message

      def initialize(message = nil)
        super
        @message = message
      end
    end
  end
end

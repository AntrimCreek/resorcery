require "rails/generators"
require "github/markup"

module Resorcery
  class HomeController < ApplicationController
    layout "resorcery"

    def index; end

    private

    def generator_params
      params.require(:generator).permit(:name, args: [])
    end
  end
end

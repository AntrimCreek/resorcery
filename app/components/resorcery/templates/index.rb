# frozen_string_literal: true

module Resorcery
  module Templates
    class Index < Resorcery::ApplicationComponent
      include Ransack::Helpers::FormHelper
      # include SimpleFormRansackHelper
      include Turbo::FramesHelper

      attr_reader :collection, :query, :query_params, :list_columns, :search_inputs

      def initialize(collection: nil, query: nil, query_params: nil, list_columns: [], search_inputs: [])
        super
        @collection = collection
        @query = query
        @query_params = query_params
        @list_columns = list_columns
        @search_inputs = search_inputs
      end
    end
  end
end

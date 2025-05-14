module Resorcery
  module ApplicationHelper
    def resource_path(resource, action = nil)
      if resource.is_a?(Class) && resource < ActiveRecord::Base
        action ||= :index
      elsif resource.is_a? ActiveRecord::Base
        action ||= :show
      end

      case action
      when :edit
        edit_polymorphic_path(resource)
      when :new
        new_polymorphic_path(resource)
      else
        polymorphic_path(resource)
      end
    end

    def recognize_resource_route(resource, action = nil)
      if resource.is_a?(Class) && resource < ActiveRecord::Base
        action ||= :index
      elsif resource.is_a? ActiveRecord::Base
        action ||= :show
      end

      case action
      when :create
        Rails.application.routes.recognize_path(resource_path(resource), method: :post) rescue nil
      when :update
        Rails.application.routes.recognize_path(resource_path(resource), method: :put) rescue nil
      when :destroy
        Rails.application.routes.recognize_path(resource_path(resource), method: :delete) rescue nil
      else
        Rails.application.routes.recognize_path(resource_path(resource, action)) rescue nil
      end
    end

    def resource_route_exists?(resource, action = nil)
      recognize_resource_route(resource, action).present?
    end
  end
end

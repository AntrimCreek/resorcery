# frozen_string_literal: true

module Resorcery
  module ResourceController
    module InstanceMethods
      # GET /resources
      def index
        if resource_search_enabled?
          @q = resource_model.ransack(params[:q])
          @q.sorts = resource_default_sorts if @q.sorts.empty?
          assign_resources @q.result.page(params[:page]).per(params[:per_page])
        else
          assign_resources resource_model.page(params[:page]).per(params[:per_page])
        end
        render_action :index
      end

      # GET /resources/1
      def show
        render_action :show
      end

      # GET /resources/new
      def new
        assign_resource resource_model.new
        render_action :form, alternate_templates: %i[new]
      end

      # GET /resources/1/edit
      def edit
        render_action :form, alternate_templates: %i[edit]
      end

      # POST /resources
      def create
        assign_resource resource_model.new(resource_params)

        respond_to do |format|
          if @resource.save
            format.html { redirect_to [@resource], notice: "#{@resource.display_name} was created." }
            # format.json { render :show, status: :created, location: @resource }
          else
            format.html { render_action :form, status: :unprocessable_entity, alternate_templates: %i[new] }
            # format.json { render json: @resource.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /resources/1
      def update
        respond_to do |format|
          if @resource.update(resource_params)
            format.html { redirect_to [@resource], notice: "#{@resource.display_name} was updated." }
            # format.json { render :show, status: :ok, location: @resource }
          else
            format.html { render_action :form, status: :unprocessable_entity, alternate_templates: %i[edit] }
            # format.json { render json: @resource.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /resources/1
      def destroy
        @resource.destroy
        respond_to do |format|
          format.html { redirect_to [resource_model], notice: "#{@resource.display_name} was deleted.", status: :see_other }
          # format.json { head :no_content }
        end
      end

      protected

      # Use callbacks to share common setup or constraints between actions.
      def set_resource
        assign_resource resource_model.find(params[:id] || params[:"#{resource_model.model_name.element}_id"])
      end

      def assign_resource(record)
        @resource = instance_variable_set("@#{resource_model.model_name.element}", record)
        # authorize @resource
      end

      def assign_resources(records)
        @resources = instance_variable_set("@#{resource_model.model_name.collection}", records)
      end

      # Only allow a list of trusted parameters through.
      def resource_params
        if respond_to?(:"#{resource_model.model_name.element}_params", true)
          send(:"#{resource_model.model_name.element}_params")
        else
          # TODO: Fix this before using in production. This is a super dangerous security risk.
          resource_model.attribute_names
          params.require(resource_model.model_name.element).permit!
        end
      end

      def user_not_authorized
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to(request.referrer || root_path)
      end

      def verify_resource_model
        raise "No Resorcery model specified for #{self.class.name}" unless resource_model.present?
      end

      def verify_format
        raise ActionController::UnknownFormat unless resource_format?(request.format.symbol)
      end

      def resource_format?(format)
        format = format.to_sym
        format = :html if format == :turbo_stream
        resource_formats.include?(format)
      end

      def render_action(action, options = {})
        templates = [*options.delete(:alternate_templates), action]
        template = find_template(templates)
        render template.presence || "resorcery/#{action}", options
      end

      def find_template(templates)
        templates.each do |template|
          return template if template_exists?(template, params[:controller])
        end
        nil
      end
    end
  end
end

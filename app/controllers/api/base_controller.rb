class Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  load_and_authorize_resource :only => [:destroy, :show, :update, :update_collection]
  respond_to :json

  # POST /api/{plural_resource_name}
  def create
    set_resource(resource_class.new(resource_params))
    unless get_resource.valid?
      @error = {:reasons => get_resource.errors.full_messages, :code => INVALID_PARAMS_ERROR}
      render_error :unprocessable_entity and return
    end
    if get_resource.save
      render :show, status: :created and return
    end
    @error = {:reasons => get_resource.errors.full_messages, :code => INVALID_PARAMS_ERROR}
    render_error status: :unprocessable_entity
  end

  # DELETE /api/{plural_resource_name}/1
  def destroy
    if get_resource.destroy
      head :accepted and return
    else
      @error = {:reasons => get_resource.errors.full_messages, :code => INVALID_PARAMS_ERROR}
      render_error :unprocessable_entity
    end
  end

  # GET /api/{plural_resource_name}
  def index
    plural_resource_name = "@#{resource_name.pluralize}"
    if query_params.blank?
      resources = list_resource
    else
      resources = resource_class.where(query_params)
    end
    instance_variable_set(plural_resource_name, resources)
    render :index, status: :ok
  end

  # GET /api/{plural_resource_name}/1
  def show
    resources = resource_class.find(params[:id])
    instance_variable_set("@#{resource_name}", resources)
    respond_with get_resource
  end

  # PATCH/PUT /api/{plural_resource_name}/1
  def update
    if get_resource.update(resource_params)
      render :show
    else
      @error = {:reasons => get_resource.errors.full_messages, :code => INVALID_PARAMS_ERROR}
      render_error :unprocessable_entity
    end
  end

  private

  # Returns the resource from the created instance variable
  # @return [Object]
  def get_resource
    instance_variable_get("@#{resource_name}")
  end

  # Returns the allowed parameters for searching
  # Override this method in each API controller
  # to permit additional parameters to search on
  # @return [Hash]
  def query_params
    {}
  end

  # Returns the allowed parameters for pagination
  # @return [Hash]
  def page_params
    params.permit(:page, :page_size)
  end

  # The resource class based on the controller
  # @return [Class]
  def resource_class
    @resource_class ||= resource_name.classify.constantize
  end

  # The singular name for the resource class based on the controller
  # @return [String]
  def resource_name
    @resource_name ||= self.controller_name.singularize
  end

  # Only allow a trusted parameter "white list" through.
  # If a single resource is loaded for #create or #update,
  # then the controller for the resource must implement
  # the method "#{resource_name}_params" to limit permitted
  # parameters for the individual model.
  def resource_params
    @resource_params ||= self.send("#{resource_name}_params")
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_resource(resource = nil)
    resource ||= resource_class.find_by!(id: params[:id])
    instance_variable_set("@#{resource_name}", resource)
  end

  # Callback for listing all record of class ${#resource_class}
  def list_resource
    resource_class.all
  end

end
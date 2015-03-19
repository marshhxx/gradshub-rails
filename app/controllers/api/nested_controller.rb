class Api::NestedController < Api::BaseController

  # POST /api/{plural_parent_resource_name}/:{parent_resource_name}_id/{plural_resource_name}
  def create
    if parent_params.blank?
      super()
    else
      create_nested
    end
  end

  # GET /api/{plural_parent_resource_name}/:{parent_resource_name}_id/{plural_resource_name}
  def index
    if parent_params.blank?
      super()
    else
      index_nested
    end
  end

  # DELETE /api/{plural_parent_resource_name}/:{parent_resource_name}_id/{plural_resource_name}/:{id}
  def destroy
    if parent_params.blank?
      super()
    else
      destroy_nested
    end
  end

  private

  def create_nested
    set_resource(resource_class.find_or_create_by(resource_params))
    set_parent_resource.send(resource_name.pluralize) << get_resource
    unless get_resource.valid?
      @error = {:reasons => get_resource.errors.full_messages, :code => INVALID_PARAMS_ERROR}
      render_error :unprocessable_entity
    end
    if get_parent_resource.save
      render :show, status: :created and return
    end
    @error = {:reasons => get_parent_resource.errors.full_messages, :code => INVALID_PARAMS_ERROR}
    render_error status: :unprocessable_entity
  end

  def index_nested
    set_parent_resource
    plural_resource_name = "@#{resource_name.pluralize}"
    if query_params.blank?
      resources = resource_class.all
    else
      resources = get_parent_resource.send(resource_name.pluralize)
    end
    instance_variable_set(plural_resource_name, resources)
    render :index, status: :ok
  end

  def destroy_nested
    set_parent_resource
    get_parent_resource.send(resource_name.pluralize).delete(get_resource)
    head :accepted and return
  end


  # Returns the parent resource from the created instance variable
  # @return [Object]
  def get_parent_resource
    instance_variable_get("@#{parent_resource_name}")
  end

  # The singular name for the resource class based on the parameter name.
  # @return [String]
  def parent_resource_name
    if params[:candidate_id]
      name = 'candidate'
    else params[:employer_id]
      name = 'employer'
    end
    @parent_resource_name ||= name
  end

  # The parent resource class based on the parameter name.
  # @return [Class]
  def parent_resource_class
    @parent_resource_class ||= parent_resource_name.classify.constantize
  end

  def parent_params
    params["#{parent_resource_name}_id"]
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_parent_resource(resource = nil)
    resource ||= parent_resource_class.find_by_uid(parent_params)
    instance_variable_set("@#{parent_resource_name}", resource)
  end
end
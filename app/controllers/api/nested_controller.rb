class Api::NestedController < Api::BaseController

  # POST /api/{plural_parent_resource_name}/:{parent_resource_name}_id/{plural_resource_name}
  def create
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

  private

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

  # Use callbacks to share common setup or constraints between actions.
  def set_parent_resource(resource = nil)
    resource ||= parent_resource_class.find_by_uid(params["#{parent_resource_name}_id"])
    instance_variable_set("@#{parent_resource_name}", resource)
  end
end
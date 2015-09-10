class Api::V1::DegreesController < Api::BaseController

  private

  # Override so we don't return Other
  def list_resource
    resource_class.all_but_other
  end

  def degree_params
    params.require(:degree).permit(:name) if params[:degree]
  end

  def query_params
    params.permit(:all)
  end
end
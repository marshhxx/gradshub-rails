class Api::V1::NationalitiesController < Api::NestedController
  wrap_parameters include: [:nationality_id]
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]

  private

  def nationality_params
    params.require(:nationality).permit(:nationality_id) if params[:nationality]
  end

  def query_params
    params.permit(:candidate_id, :id)
  end

  def create_resource
    resource_class.find(resource_params[:nationality_id])
  end
end
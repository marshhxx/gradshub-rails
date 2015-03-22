class Api::V1::NationalitiesController < Api::NestedController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]

  private

  def nationality_params
    params.require(:nationality).permit(:name) if params[:nationality]
  end

  def query_params
    params.permit(:candidate_id, :id)
  end

  def create_resource
    resource_class.find_by_name(resource_params[:name])
  end
end
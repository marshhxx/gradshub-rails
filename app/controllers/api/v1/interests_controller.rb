class Api::V1::InterestsController < Api::NestedController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy, :update_collection]

  private

  def interest_params
    params.require(:interest).permit(:name) if params[:interest]
  end

  def interests_params
    params.permit([:interests => [:name]]) if params[:interests]
  end

  def query_params
    params.permit(:candidate_id, :employer_id, :id)
  end

  def create_resource
    resource_class.find_or_create_by(resource_params)
  end
end
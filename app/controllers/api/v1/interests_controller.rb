class Api::V1::InterestsController < Api::BaseController
  before_action :authenticate_with_token!, only: [:create]

  private

  def interest_params
    params.require(:interest).permit(:name) if params[:interest]
  end

  def query_params
    params.permit(:all)
  end
end
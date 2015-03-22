class Api::V1::NationalitiesController < Api::NestedController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]

  private

  def nationality_params
    params.require(:nationality).permit(:name) if params[:nationality]
  end

  def query_params
    # this assumes that an album belongs to an artist and has an :artist_id
    # allowing us to filter by this
    params.permit(:all)
  end
end
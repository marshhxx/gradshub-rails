class Api::V1::LanguagesController < Api::BaseController
  before_action :authenticate_with_token!, only: [:create]

  private

  def language_params
    params.require(:language).permit(:name) if params[:language]
  end

  def query_params
    # this assumes that an album belongs to an artist and has an :artist_id
    # allowing us to filter by this
    params.permit(:all)
  end
end
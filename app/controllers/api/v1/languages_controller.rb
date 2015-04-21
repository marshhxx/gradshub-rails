class Api::V1::LanguagesController < Api::BaseController
  before_action :authenticate_with_token!, only: [:create, :destroy]

  protected

  def language_params
    params.require(:language).permit(:language_id, :level) if params[:language]
  end

  def query_params
    params.permit(:all)
  end
end
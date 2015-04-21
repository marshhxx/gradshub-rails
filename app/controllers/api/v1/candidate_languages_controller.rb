class Api::V1::CandidateLanguagesController < Api::NestedController
  before_action :authenticate_with_token!, only: [:create, :destroy]
  wrap_parameters :language, include: [:language_id, :level]

  protected

  def create_resource
    CandidateLanguage.new(language_params)
  end

  def language_params
    params.require(:language).permit(:language_id, :level) if params[:language]
  end

  def query_params
    params.permit(:candidate_id, :id)
  end
end
class Api::V1::CandidateLanguagesController < Api::NestedController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]
  wrap_parameters :language, include: [:language_id, :level]

  protected

  def create_resource
    CandidateLanguage.new(candidate_language_params)
  end

  def candidate_language_params
    params.require(:language).permit(:language_id, :level) if params[:language]
  end

  def query_params
    params.permit(:candidate_id, :id)
  end

  def class_name
    'Language'
  end
end
class Api::V1::SkillsController < Api::BaseController
  before_action :authenticate_with_token!, only: [:create]

  private

  def skill_params
    params.require(:skill).permit(:name) if params[:skill]
  end

  def query_params
    params.permit(:all)
  end
end
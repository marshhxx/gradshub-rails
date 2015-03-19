class Api::V1::SkillsController < Api::NestedController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]

  private

  def skill_params
    params.require(:skill).permit(:name, :id) if params[:skill]
  end

  def query_params
    params.permit(:candidate_id, :id)
  end
end
class Api::V1::SkillsController < Api::NestedController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy, :update_collection]

  private

  def skill_params
    params.require(:skill).permit(:name, :id) if params[:skill]
  end

  def skills_params
    params.permit([:skills => [:name]])if params[:skills]
  end

  def query_params
    params.permit(:candidate_id, :job_post_id, :id)
  end

  def create_resource
    resource_class.find_or_create_by(resource_params)
  end
end
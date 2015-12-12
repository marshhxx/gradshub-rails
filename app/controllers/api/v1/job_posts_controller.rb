class Api::V1::JobPostsController < Api::NestedController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]

  def index
    @job_posts = JobPost.where employer_id: params['employer_id']
  end

  private

  def query_params
    params.permit(:e)
  end

  def job_post_params
    params.require(:job_post).permit(
        :title, :description, :requirements, :job_type, :salary_unit, :min_salary, :max_salary,
        :start_date, :end_date, :job_state, :remote, :category, :state_id, :country_id) if params[:job_post]
  end

end
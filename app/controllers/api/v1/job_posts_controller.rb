class Api::V1::JobPostsController < Api::BaseController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]
  before_action :modify_employer_id, only: [:create, :update]
  private

  def query_params
    params.permit(:all)
  end

  def job_post_params
    params.require(:job_post).permit(
        :title, :description, :requirements, :job_type, :salary_unit, :min_salary, :max_salary,
        :start_date, :end_date, :job_state, :remote, :employer_id, :state_id, :country_id,
        :employer_id) if params[:job_post]
  end

  def modify_employer_id
    params[:job_post][:employer_id] = Employer.find_by_uid(params[:job_post][:employer_id]).id
  end

end
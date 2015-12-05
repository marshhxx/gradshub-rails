
class Api::V1::JobPostsController < Api::BaseController
  before_action :authenticate_with_token!, only: [:create]

  def create

    set_resource(create_resource)
    unless get_resource.valid?
      @error = { :reasons => get_resource.jobPost.errors.full_message, :code => INVALID_PARAMS_ERROR }
      render_api_error and return
    end
    if get_resource.save
      render :show, status: :created and return
    end
    logger.info 'Post Job Created'
    render :nothing => true, :status => :created and return
  end


  private

  def create_resource
    resource_class.new(resource_params)
  end

  def query_params
    params.permit(:all)
  end

  def job_post_params
    params.require(:job_post).permit(
        :title, :description, :requirements, :job_post_type, :salary_unit, :min_salary, :max_salary,
        :start_date, :end_date, :state, :remote, :employer_id, :state_id, :country_id) if params[:job_post]
  end

end
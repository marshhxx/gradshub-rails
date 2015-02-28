class Api::V1::CareersController < Api::BaseController
  before_action :authenticate_with_token!, only: [:create]

  def create
    user = User.find_by!(uid: params[:user_id])
    @career = Career.create(career_params)
    if career.nil?
      @reasons = get_resource.errors
      render 'api/v1/common/error', status: :unprocessable_entity
    else
      user.careers << career
      render :show, status: :created
    end
  end

  private

  def career_params
    params.require(:career).permit(
        :company_name, :job_position,
        :start_date, :end_date,
        :description
    ) if params[:country]
  end

  def query_params
    params.permit(:all)
  end
end
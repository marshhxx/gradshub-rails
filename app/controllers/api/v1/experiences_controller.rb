class Api::V1::ExperiencesController < Api::NestedController
  before_action :authenticate_with_token!, only: [:create, :destroy, :update]

  private

  def experience_params
    params.require(:experience).permit(
        :company_name, :job_title,
        :start_date, :end_date,
        :description
    ) if params[:experience]
  end

  def query_params
    params.permit(:candidate_id, :id)
  end

  def sort_resources(collection)
    collection.order(:start_date).reverse
  end
end
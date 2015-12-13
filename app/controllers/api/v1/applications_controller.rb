class Api::V1::ApplicationsController < Api::NestedController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]
  before_action :modify_candidate_id, only: [:update]

  private
  def query_params
    params.permit(:candidate_id, :job_post_id)
  end

  def application_params
    params.require(:application).permit(
        :state, :candidate_id) if params[:application]
  end

  def modify_candidate_id
    params[:application][:candidate_id] = Candidate.find_by_uid(params[:application][:candidate_id]).id
  end
end
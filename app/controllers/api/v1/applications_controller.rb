class Api::V1::ApplicationsController < Api::NestedController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]
  before_action :modify_candidate_id, only: [:update]
  before_action :validate_candidate_id, only: [:update]

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

  def validate_candidate_id
    unless @application.candidate_id == params['application']['candidate_id']
      @error = {:reasons => ['The employer cannot modify candidate id'], :code => AUTH_ERROR}
      render 'api/v1/common/error', status: :unauthorized and return
    end
  end
end
class Api::V1::CandidatesController < Api::V1::UsersController

  private

  def candidate_params
    nest_user_attributes params.require(:candidate).permit(:early_life, :personal_life, :job_title, :country_id,
                                        :state_id, :name, :lastname, :email, :password, :onepgr_password, :gender,
                                        :birth, :image_url, :tag) if params[:candidate]
  end
end
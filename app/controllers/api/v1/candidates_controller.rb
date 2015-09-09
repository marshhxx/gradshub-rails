class Api::V1::CandidatesController < Api::V1::UsersController
  wrap_parameters include: [:early_life, :personal_life, :job_title, :summary, :country_id,
                            :state_id, :name, :lastname, :email, :password, :gender,
                            :birth, :profile_image, :cover_image, :tag]
  private

  def candidate_params
    nest_user_attributes params.require(:candidate).permit(
        :early_life, :personal_life, :job_title, :summary, :country_id,
        :state_id, :name, :lastname, :email, :password, :gender,
        :birth, :profile_image, :cover_image, :tag
    ) if params[:candidate]
  end
end
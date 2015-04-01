class Api::V1::EmployersController < Api::V1::UsersController
  wrap_parameters include: [:name, :lastname, :email, :password, :onepgr_password, :gender,
                              :birth, :profile_image, :cover_image, :tag, :job_title]

  private

  def employer_params
    nest_user_attributes params.require(:employer).permit(
                             :name, :lastname, :email, :password, :onepgr_password, :gender,
                             :birth, :profile_image, :cover_image, :tag, :job_title) if params[:employer]
  end

  def company_params
    params.require(:employer).permit(:company => [:name, :industry, :description])
  end

  def location_params
    params.require(:employer).permit(:company => [:locations => [:country_id, :state_id]])
  end
end
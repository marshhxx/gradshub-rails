class Api::V1::EmployersController < Api::V1::UsersController

  private

  def company
    location = CompanyLocation.find_or_create_by(location_params[:company][:location_params])
    company = Company.find_or_create_by(company_params[:company])
    company.company_locations << location
    company
  end

  def create_resource
    resource_class.new(resource_params, :company => company)
  end

  def employer_params
    nest_user_attributes params.require(:employer).permit(
                             :name, :lastname, :email, :password, :onepgr_password, :gender,
                             :birth, :image_url, :tag) if params[:employer]
  end

  def company_params
    params.require(:employer).permit(:company => [:name, :industry, :description])
  end

  def location_params
    params.require(:employer).permit(:company => [:locations => [:country_id, :state_id]])
  end
end
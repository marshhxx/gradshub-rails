class Api::V1::CompaniesController < Api::NestedController
  wrap_parameters include: [:name, :industry, :company_id, :description, :state_id, :country_id, :site_url, :image]
  before_action :authenticate_with_token!, only: [:create, :update]
  before_action :set_resource, :only => []
  before_action :set_parent_resource, :only => [:show, :update]

  def update
    get_parent_resource.employer_company.destroy! if get_parent_resource.employer_company
    create_nested
  end

  def show
    set_resource(get_parent_resource.employer_company)
    render :employer_company, status: :accepted
  end

  protected

  def create_nested
    set_parent_resource
    set_resource(get_parent_resource.employer_company = EmployerCompany.new(employer_company_params))
    get_resource.company = Company.find(company_params[:company_id])
    get_parent_resource.save!
    render :employer_company, status: :created
  end

  def company_params
    params.require(:company).permit(
        :specialties, :headquarters_state, :headquarters_country,
        :size, :type, :name, :industry, :description, :company_id
    ) if params[:company]
  end

  def employer_company_params
    params.require(:company).permit(:description, :state_id, :country_id, :site_url, :image) if params[:company]
  end

  def query_params
    params.permit(:id, :employer_id, :all)
  end

  def record_not_found
    if params[:action] == :show
      reasons = ["Company with id #{company_params[:company_id]} doesn't exist."]
    else
      reasons = ["Employer #{params[:employer_id]} doesn't have a company."]
    end
    @error = {:reasons => reasons, :code => INVALID_PARAMS_ERROR}
    render :json => @error
  end
end
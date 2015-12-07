class Api::V1::CountriesController < Api::BaseController
  before_action :authenticate_with_token!, only: [:create]

  private

  def country_params
    params.require(:country).permit(:name) if params[:country]
  end

  def query_params
    params.permit(:all)
  end


  def list_resource
    resource_class.all.order(name: :asc)
  end
end
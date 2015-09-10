class Api::V1::EducationsController < Api::NestedController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]

  private

  def create_resource
    Education.create_with_other(resource_params)
  end

  def education_params
    params.require(:education).permit(:school_id, :other_school, :major_id, :other_major, :degree_id, :other_degree,
                                      :state_id, :country_id, :degree_id, :description,
                                      :start_date, :end_date) if params[:education]
  end

  def query_params
    params.permit(:candidate_id, :id)
  end

  def sort_resources(collection)
    collection.order(:start_date).reverse
  end
end
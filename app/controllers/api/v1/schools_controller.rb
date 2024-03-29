class Api::V1::SchoolsController < Api::BaseController
  before_action :authenticate_with_token!, only: [:create]

  private

  # Override so we don't return Other
  def list_resource
    resource_class.all_but_other
  end

  def school_params
    params.require(:school).permit(:name) if params[:school]
  end

  def query_params
    # this assumes that an album belongs to an artist and has an :artist_id
    # allowing us to filter by this
    params.permit(:all)
  end
end
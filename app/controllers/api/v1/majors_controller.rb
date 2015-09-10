class Api::V1::MajorsController < Api::BaseController

  private

  # Override so we don't return Other
  def list_resource
    resource_class.all_but_other
  end

  def major_params
    params.require(:major).permit(:name) if params[:major]
  end

  def query_params
    params.permit(:all)
  end
end
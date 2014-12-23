class Api::V1::DegreesController < Api::BaseController

  private

  def degree_params
    params.require(:degree).permit(:name) if params[:degree]
  end

  def query_params
    params.permit(:all)
  end
end
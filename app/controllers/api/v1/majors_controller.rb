class Api::V1::MajorsController < Api::BaseController

  private

  def major_params
    params.require(:major).permit(:name) if params[:major]
  end

  def query_params
    params.permit(:all)
  end
end
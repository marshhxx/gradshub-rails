class Api::V1::StatesController < Api::BaseController
  before_action :authenticate_with_token!, only: [:create]

  private

  def state_params
    params.require(:state).permit(:name) if params[:state]
  end

  def query_params
    params.permit(:country_id, :id)
  end

  # Callback for listing all record of class ${#resource_class}
  def list_resource
    resource_class.all.order(name: :asc)
  end

end
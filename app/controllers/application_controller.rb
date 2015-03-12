class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include Authenticable

  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  def not_found(exception)
    @error = {:reasons => [exception.message], :code => INVALID_PARAMS_ERROR}
    render :json => @error
  end

  def render_api_error
    render_error :unprocessable_entity
  end

  def render_error(status)
    render 'api/v1/common/error', status: status
  end

end
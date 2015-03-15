class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include Authenticable

  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  rescue_from ActionController::ParameterMissing, :with => :bad_request

  def not_found
    @error = {:reasons => [["Resource with id #{params[:id]} doesn't exist."]], :code => INVALID_PARAMS_ERROR}
    render :json => @error
  end

  def bad_request(exception)
    @error = {:reasons => [exception.message], :code => INVALID_PARAMS_ERROR}
    render_error :bad_request
  end

  def render_api_error
    render_error :unprocessable_entity
  end

  def render_error(status)
    render 'api/v1/common/error', status: status
  end

end
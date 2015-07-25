class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include Authenticable

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from ActionController::ParameterMissing, :with => :bad_request
  rescue_from ArgumentError, :with => :bad_request
  rescue_from CanCan::AccessDenied, :with => :unauthorized
  rescue_from ActiveRecord::RecordNotUnique, :with => :not_unique
  rescue_from CloudinaryException, :with => :bad_request

  def unauthorized
    @error = {:reasons => ['The user has no permission to perform this action.'], :code => FORBIDDEN}
    render_error :forbidden
  end

  def record_not_found
    @error = {:reasons => ["Resource with id #{params[:id]} doesn't exist."], :code => INVALID_PARAMS_ERROR}
    render_error :bad_request
  end

  def not_found(exception)
    @error = {:reasons => [exception.message], :code => INVALID_PARAMS_ERROR}
    render_error :bad_request
  end

  def not_unique(exception)
    @error = {:reasons => [exception.message], :code => INVALID_PARAMS_ERROR}
    render_error :bad_request
  end

  def bad_request(exception)
    @error = {:reasons => [exception.message], :code => INVALID_PARAMS_ERROR}
    render_error :bad_request
  end

  def render_api_error
    render_error :bad_request
  end

  def render_error(status)
    render 'api/v1/common/error', status: status
  end

end
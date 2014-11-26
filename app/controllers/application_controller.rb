class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include Authenticable

  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  def not_found(exception)
      render :json => {:error => {:message => exception.message}}, :status => :not_found
  end

end
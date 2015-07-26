class Api::V1::ImagesController < ApplicationController

  before_filter :check_configuration
  before_action :authenticate_with_token!, only: [:upload]

  def upload
    if params[:file].blank?
      render_api_error and return
    end

    @response = Cloudinary::Uploader.upload(params[:file],
      :tags => "users_photos",
      :transformation => transformation_options)

    render :upload, :status => :accepted
  end

  def delete
    if params[:public_id].blank?
      render_api_error and return
    end

    @response = Cloudinary::Api.delete_resources(params[:public_id])

    render :delete, :status => :accepted
  end

  private
  def transformation_options
    { :crop => "limit", :width => 1920, :height => 1080 }
  end
  
  def check_configuration
    render 'configuration_missing' if Cloudinary.config.api_key.blank?
  end


end

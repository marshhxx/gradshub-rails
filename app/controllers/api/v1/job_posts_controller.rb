require 'active_support'

class Api::V1::JobPostsController < Api::BaseController
  wrap_parameters include: [:title, :description, :requirements, :type, :salary_unit, :min_salary, :max_salary,
                            :start_date, :end_date, :state]

  before_action :authenticate_with_token!, only: []

  def create
    JobPost
    render :nothing => true, :status => :created and return
  end


  private

  def create_resource
    resource_class.new(resource_params)
  end

end
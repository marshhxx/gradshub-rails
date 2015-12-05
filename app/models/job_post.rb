class JobPost < ActiveRecord::Base
  belongs_to :employer
  belongs_to :country
  belongs_to :state

  update_index 'users#employer', :employer

  enum job_post_type: { internship: 0, full_time: 1, part_time: 2, project_based: 3 }
  enum salary_unit: { US: 0 }
  enum state: { in_progress: 0, stopped: 1 , draft: 2 }

  validates_presence_of :title

  def self.where(params)
    params[:employer_id] = User.find_by_uid!(params[:employer_id]).meta.id
    super.where(params)
  end
end
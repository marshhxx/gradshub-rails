class JobPost < ActiveRecord::Base
  belongs_to :employer
  belongs_to :country
  belongs_to :state

  has_many :job_post_skills
  has_many :skills, :through => :job_post_skills

  enum job_type: {internship: 0, full_time: 1, part_time: 2, project_based: 3}
  enum salary_unit: {US: 0}
  enum job_state: {in_progress: 0, stopped: 1, draft: 2}

  validates_presence_of :title

  def self.where(params)
    params[:employer_id] = User.find_by_uid!(params[:employer_id]).meta.id
    super.where(params)
  end

  def self.find_by_uid(uid)
    self.find(uid)
  end
end
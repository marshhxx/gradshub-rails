class JobPost < ActiveRecord::Base
  belongs_to :employer
  belongs_to :country
  belongs_to :state

  has_many :job_post_skills
  has_many :skills, :through => :job_post_skills

  enum job_type: {internship: 0, full_time: 1, part_time: 2, project_based: 3}
  enum salary_unit: {US: 0}
  enum job_state: {in_progress: 0, stopped: 1, draft: 2}

  validates_presence_of :title, :requirements, :job_type, :start_date, :end_date
  validates_numericality_of :max_salary, :greater_than_or_equal_to => :min_salary, :allow_blank => true
  validate :start_date_cannot_be_greater_than_end_date
  validates_associated :employer

  def self.where(params)
    params[:employer_id] = User.find_by_uid!(params[:employer_id]).meta.id
    super.where(params)
  end

  def self.find_by_uid(uid)
    self.find(uid)
  end

  def start_date_cannot_be_greater_than_end_date
    if end_date.present? and start_date.present? && start_date > end_date
      errors.add(:base, "Start date cannot be greater than end date")
    end
  end
end
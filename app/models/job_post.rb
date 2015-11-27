class JobPost < ActiveRecord::Base
  belongs_to :employer
  enum type: [:internship, :full_time, :part_time, :project_based]
  enum salary_unit: [:US]
  enum state: [:in_progress, :stopped]

  # update index
  update_index 'users#employer', :employer



  validates_presence_of :title, :employer_id



end
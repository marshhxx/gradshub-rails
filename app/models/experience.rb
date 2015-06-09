class Experience < ActiveRecord::Base
  belongs_to :candidate

  validates_presence_of :company_name, :start_date, :job_title
  validates_uniqueness_of :company_name, scope: [:candidate_id, :job_title],
      :message => 'Experience already exists.'

end
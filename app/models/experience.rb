class Experience < ActiveRecord::Base
  validates_presence_of :company_name, :start_date, :job_title
  belongs_to :candidate
end
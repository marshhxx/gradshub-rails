class Application < ActiveRecord::Base

  belongs_to :candidate
  belongs_to :job_post

  enum state: {backlog: 0, requested: 1, interviewing: 2, made_offer: 3}

  validates_presence_of :state
  validates_associated :candidate, :job_post

end
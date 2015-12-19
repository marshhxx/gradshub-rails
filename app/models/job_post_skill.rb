class JobPostSkill < ActiveRecord::Base
  belongs_to :job_post
  belongs_to :skill

  validates_uniqueness_of :skill_id, scope: :job_post_id
end
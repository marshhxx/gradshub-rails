json.experiences @experiences do |experience|
  json.id experience.id
  json.candidate_id experience.candidate.user.uid
  json.company_name experience.company_name
  json.job_title experience.job_title
  json.description experience.description
  json.start_date experience.start_date
  json.end_date experience.end_date
end
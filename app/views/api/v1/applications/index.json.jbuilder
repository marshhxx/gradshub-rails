json.applications @applications do |application|
  json.id application.id
  json.candidate_id application.candidate_id
  json.job_post_id application.job_post_id
  json.state application.state
  json.created_at application.created_at
end
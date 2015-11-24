json.jobPosts @job_posts do |jobPost|
  json.id jobPost.id
  json.description jobPost.description
  json.employer_id jobPost.employer_id
  json.requirements jobPost.requirements
  json.job_type jobPost.job_type
  json.salary_unit jobPost.salary_unit
  json.min_salary jobPost.min_salary
  json.max_salary jobPost.max_salary
  json.start_date jobPost.start_date
  json.end_date jobPost.end_date
  json.job_state jobPost.job_state
  json.country jobPost.country
  json.state jobPost.state
end

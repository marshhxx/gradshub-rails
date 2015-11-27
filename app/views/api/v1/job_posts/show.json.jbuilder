json.job_post do
  json.id @job_post.id
  json.employer_id @job_post.employer.user.uid
  json.description @job_post.desciption
  json.requirements @job_post.requirements
  json.type @job_post.type
  json.salary_units @job_post.salary_units
  json.min_salary @job_post.min_salary
  json.max_salary @job_post.max_salary
  json.start_date @job_post.start_date
  json.end_date @job_post.end_date

end

json.jobPosts @job_posts.order(:start_date).reverse do |jobPost|
  json.id jobPost.id
  json.description jobPost.descrption
  json.requirements jobPost.requirements
  json.type jobPost.type
  json.salary_unit jobPost.salary_unit
  json.min_salary jobPost.min_salary
  json.max_salary jobPost.max_salary
  json.start_date jobPost.start_date
  json.end_date jobPost.end_date
  json.state jobPost.state
end
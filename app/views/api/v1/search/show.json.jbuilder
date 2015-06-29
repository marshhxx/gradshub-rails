json.users @users do |user|
  json.uid      user.user.uid
  json.name     user.user.name
  json.lastname user.user.lastname
  json.email    user.user.email
  json.tag      user.user.tag
  json.profile_image user.user.profile_image
  if user.user.meta_type == 'Candidate'
    current_postion = (user.experiences.map {|e| e if !e.end_date}).sort {|left, right| left.start_date <=> right.start_date}[0].job_title
  else
    current_postion = user.job_title
  end
  json.current_position current_postion
end
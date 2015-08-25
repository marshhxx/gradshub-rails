json.users @users.compact do |user|
  json.uid user.user.uid
  json.name user.user.name
  json.lastname user.user.lastname
  json.email user.user.email
  json.tag user.user.tag
  json.profile_image user.user.profile_image
  json.gender user.user.gender
  if user.current_position
    json.current_position user.current_position.job_title
    json.company user.current_position.company_name
  end
end

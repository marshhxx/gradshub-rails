json.users @users do |user|
  json.uid user.user.uid
  json.type user.user.meta_type
  json.name user.user.name
  json.lastname user.user.lastname
  json.email user.user.email
  json.tag user.user.tag
  json.profile_image user.user.profile_image
  json.gender user.user.gender
  json.current_position user.current_position.job_title if user.current_position
  json.company user.current_position.company_name if user.current_position
end

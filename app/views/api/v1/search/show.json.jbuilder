json.users @users do |user|
  json.uid user.user.uid
  json.type user.user.meta_type
  json.name user.user.name
  json.lastname user.user.lastname
  json.email user.user.email
  json.tag user.user.tag
  json.profile_image user.user.profile_image
  json.gender user.user.gender
  json.current_position user.user.job_title
  json.company user.user.company_name
end

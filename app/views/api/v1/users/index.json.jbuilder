json.users @users do |user|
  json.name    user.name
  json.lastname user.lastname
  json.email  user.email
  json.password user.password

end
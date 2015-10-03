json.session do
  json.uid @user.uid
  json.email @user.email
  json.auth_token @user.token
  json.type @user.meta_type
end

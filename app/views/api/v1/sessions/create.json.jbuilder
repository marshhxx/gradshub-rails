json.user do
  json.name    @user.name
  json.lastname @user.lastname
  json.email  @user.email
  json.auth_token  @user.auth_token
end

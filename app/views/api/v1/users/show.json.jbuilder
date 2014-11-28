json.user do
  json.name     @user.name
  json.lastname @user.lastname
  json.email    @user.email
  json.password @user.password
  json.birth    @user.birth
  json.country  @user.country
  json.state    @user.state
end
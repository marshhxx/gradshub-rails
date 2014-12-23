json.user do
  json.name     @user.name
  json.lastname @user.lastname
  json.email    @user.email
  json.password @user.password
  json.birth    @user.birth
  json.country  @user.country
  json.state    @user.state
  json.bio      @user.bio
  json.nationalities @user.nationalities
  json.educations  @user.educations do |education|
    json.country education.country
    json.state  education.state
    json.degree education.degree
    json.major  education.major
    json.school education.school
  end
  json.skills  @user.skills
  json.interests @user.interests
end
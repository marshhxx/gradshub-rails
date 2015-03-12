json.candidate do
  json.uid      @employer.user.uid
  json.name     @employer.user.name
  json.lastname @employer.user.lastname
  json.email    @employer.user.email
  json.birth    @employer.user.birth
  json.tag      @employer.user.tag
  json.skills  @employer.skills
  json.interests @employer.interests
end
json.candidate do
  json.uid      @candidate.user.uid
  json.name     @candidate.user.name
  json.lastname @candidate.user.lastname
  json.email    @candidate.user.email
  json.birth    @candidate.user.birth
  json.country  @candidate.country
  json.state    @candidate.state
  json.tag      @candidate.user.tag
  json.nationalities @candidate.nationalities
  json.educations  @candidate.educations do |education|
    json.country education.country
    json.state  education.state
    json.degree education.degree
    json.major  education.major
    json.school education.school
  end
  json.skills  @candidate.skills
  json.interests @candidate.interests
end
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
    json.id education.id
    json.country education.country
    json.state education.state
    json.major education.major
    json.degree education.degree
    json.school education.school
    json.description education.description
    json.start_date education.start_date
    json.end_date education.end_date
  end
  json.skills  @candidate.skills
  json.interests @candidate.interests
  json.summary @candidate.summary
  json.cover_image @candidate.user.cover_image
  json.profile_image @candidate.user.profile_image
end
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
  json.experiences @candidate.experiences do |experience|
    json.id experience.id
    json.candidate_id experience.candidate.user.uid
    json.company_name experience.company_name
    json.job_title experience.job_title
    json.description experience.description
    json.start_date experience.start_date
    json.end_date experience.end_date
  end
  json.skills  @candidate.skills
  json.interests @candidate.interests
  json.languages @candidate.candidate_languages do |language|
    json.id     language.id
    json.name   language.language.name
    json.language_id language.language.id
    json.level  language.level.capitalize
  end
  json.summary @candidate.summary
  json.cover_image @candidate.user.cover_image
  json.profile_image @candidate.user.profile_image
end
json.employer do
  json.uid      @employer.user.uid
  json.name     @employer.user.name
  json.lastname @employer.user.lastname
  json.email    @employer.user.email
  json.birth    @employer.user.birth
  json.gender   @employer.user.gender
  json.tag      @employer.user.tag
  json.country @employer.user.country
  json.state @employer.user.state
  json.skills  @employer.skills
  json.interests @employer.interests
  json.nationalities @employer.nationalities
  json.company do
    json.name         @employer.user.company_name
    json.description  @employer.user.description
    json.site_url     @employer.user.company_url
    json.tagline      @employer.user.company_tagline
    json.logo         @employer.user.company_logo
  end
  json.profile_image @employer.user.profile_image
  json.cover_image @employer.user.cover_image
  json.job_title @employer.job_title
end
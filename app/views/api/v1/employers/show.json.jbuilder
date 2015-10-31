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
    json.name         @employer.user.meta.company_name
    json.description  @employer.user.meta.company_description
    json.site_url     @employer.user.meta.company_url
    json.tagline      @employer.user.meta.company_tagline
    json.logo         @employer.user.meta.company_logo
    json.industry     @employer.user.meta.company_industry
  end
  json.profile_image @employer.user.profile_image
  json.cover_image @employer.user.cover_image
  json.job_title @employer.job_title
end
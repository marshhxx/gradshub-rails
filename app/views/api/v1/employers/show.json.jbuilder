json.employer do
  json.uid      @employer.user.uid
  json.name     @employer.user.name
  json.lastname @employer.user.lastname
  json.email    @employer.user.email
  json.birth    @employer.user.birth
  json.gender   @employer.user.gender
  json.tag      @employer.user.tag
  json.skills  @employer.skills
  json.interests @employer.interests
  json.company do
    if @employer.employer_company
      json.company_id   @employer.employer_company.company.id
      json.name         @employer.employer_company.company.name
      json.industry     @employer.employer_company.company.industry
      json.description  @employer.employer_company.description
      json.state        @employer.employer_company.state
      json.country      @employer.employer_company.country
      json.site_url     @employer.employer_company.site_url
      json.image        @employer.employer_company.image
    end
  end
  json.profile_image @employer.user.profile_image
  json.cover_image @employer.user.cover_image
  json.job_title @employer.job_title
end
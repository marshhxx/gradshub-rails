json.employer do
  json.uid      @employer.user.uid
  json.name     @employer.user.name
  json.lastname @employer.user.lastname
  json.email    @employer.user.email
  json.birth    @employer.user.birth
  json.tag      @employer.user.tag
  json.skills  @employer.skills
  json.interests @employer.interests
  json.company do
    if @employer.employer_company
      json.name         @employer.employer_company.company.name
      json.industry     @employer.employer_company.company.industry
      json.description  @employer.employer_company.description
      json.state        @employer.employer_company.state
      json.country      @employer.employer_company.country
    end
  end
  json.company_image @employer.company_image
  json.job_title @employer.job_title
end
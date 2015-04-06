json.employer do
  json.uid      @employer.user.uid
  json.name     @employer.user.name
  json.lastname @employer.user.lastname
  json.email    @employer.user.email
  json.birth    @employer.user.birth
  json.tag      @employer.user.tag
  json.skills  @employer.skills
  json.interests @employer.interests
  json.company @employer.employer_company do |company|
    json.name         company.company.name
    json.industry     company.company.industry
    json.description  company.description
    json.state        company.state
    json.country      company.country
  end
end
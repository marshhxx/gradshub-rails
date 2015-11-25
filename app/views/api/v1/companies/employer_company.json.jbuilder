json.company do
  json.company_id @company.company.id
  json.name @company.company.name
  json.industry @company.company.industry
  json.description @company.description
  json.state @company.state
  json.country @company.country
  json.site_url @company.site_url
  json.image @company.image
end
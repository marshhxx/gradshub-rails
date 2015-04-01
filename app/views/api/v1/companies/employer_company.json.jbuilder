json.company do
  json.name @company.company.name
  json.industry @company.company.industry
  json.description @company.description
  json.state @company.state
  json.country @company.country
  json.site_url @company.site_url
  json.image @company.image
end
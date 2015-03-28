json.company do
  json.name @company.company.name
  json.industry @company.company.industry
  json.description @company.description
  json.state @company.state
  json.country @company.country
end
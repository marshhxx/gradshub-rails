json.educations @educations.order(:start_date).reverse do |education|
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
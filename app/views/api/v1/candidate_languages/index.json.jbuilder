json.languages @candidate_languages do |language|
  json.id     language.id
  json.name   language.language.name
  json.level  language.level.capitalize
end
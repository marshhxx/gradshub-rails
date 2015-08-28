json.languages @candidate_languages do |language|
  json.id              @candidate_language.id
  json.language_id     @candidate_language.language.id
  json.name            language.language.name
  json.level           language.level.capitalize
end
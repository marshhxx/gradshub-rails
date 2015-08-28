json.language do
  json.id              @candidate_language.id
  json.language_id     @candidate_language.language.id
  json.name            @candidate_language.language.name
  json.level           @candidate_language.level.capitalize
end
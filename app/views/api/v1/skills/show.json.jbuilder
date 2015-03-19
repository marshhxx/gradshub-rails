json.skill do
  json.id   @skill.id
  json.name @skill.name.capitalize!
end
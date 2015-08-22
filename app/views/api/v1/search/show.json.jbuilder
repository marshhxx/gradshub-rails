json.users @users.compact do |user|
  json.uid user.user.uid
  json.name user.user.name
  json.lastname user.user.lastname
  json.email user.user.email
  json.tag user.user.tag
  json.profile_image user.user.profile_image
  if user.user.meta_type == 'Candidate'
    ongoing = user.experiences.map { |e| e if !e.end_date }.compact
    positions = ongoing.any? ? ongoing : user.experiences
    sorted = positions.sort {
        |left, right| left.start_date <=> right.start_date
    }
    if sorted.any?
      current_position = sorted[0].job_title
      company_name = sorted[0].company_name
    else
      current_position = ''
      company_name = ''
    end
  else
    current_position = user.job_title
    company_name = user.employer_company.company.name if user.employer_company
  end
  json.current_position current_position
  json.company company_name
end

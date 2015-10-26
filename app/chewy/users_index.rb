class UsersIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      email: {
          type: 'keyword',
          tokenizer: 'uax_url_email',
          filter: ['standard', 'lowercase', 'stop']
      }
    }
  }

  define_type Candidate.includes(:user, :skills, :interests, :experiences, :educations) do
      field :name, value: -> { user.name }
      field :lastname, value: -> { user.lastname }
      field :email, analyzer: 'email', value: -> { user.email }
      field :tag, value: -> { user.tag }
      field :type, index: 'not_analyzed', value: -> { user.meta_type }
      field :summary, boost: 0.2
      # skills and interests
      field :skills, value: -> { skills.map(&:name) }
      field :interests, value: -> { interests.map(&:name) }
      # education
      field :education_schools, value: -> { educations.map { |e| e.school.name}}
      field :education_major, value: -> { educations.map { |e| e.major.name}}
      field :education_degree, value: -> { educations.map { |e| e.degree.name}}
      field :education_description, boost: 0.5, value: -> {educations.map(&:description).flatten}
      # experience
      field :experience_titles, value: -> { experiences.map(&:job_title)}
      field :experience_company, value: -> { experiences.map(&:company_name)}
      field :experience_description, boost: 0.5, value: -> {experiences.map(&:description).flatten}

  end

  define_type Employer.includes(:user, :skills, :interests) do
    field :name, value: -> { user.name }
    field :lastname, value: -> { user.lastname }
    field :email, analyzer: 'email', value: -> { user.email }
    field :tag, index: 'not_analyzed', value: -> { user.tag }
    field :type, index: 'not_analyzed', value: -> { user.meta_type }
    field :job_title # should we unboost this?
    # skills and interests
    field :skills, value: -> { skills.map(&:name) }
    field :interests, value: -> { interests.map(&:name) }
    # company
    field :company_name, value: -> { user.meta.company_name }
    field :company_description, boost: 0.5, value: -> { user.meta.description }
  end

end
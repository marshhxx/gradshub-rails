class Experience < ActiveRecord::Base
  belongs_to :candidate
  # update index
  update_index 'users#candidate', :candidate

  validates_presence_of :company_name, :start_date, :job_title
  validates_uniqueness_of :company_name, scope: [:candidate_id, :job_title],
      :message => 'Experience already exists.'

  # Creates a experience from a linkedin position.
  # Should we also store the company?
  def self.from_linkedin(position)
    Company.from_linkedin(position.company) if position.company
    self.new(
        company_name: position.company.name,
        job_title: position.title,
        start_date: "01/#{position.start_date.month}/#{position.start_date.year}".to_date,
        end_date: !position.is_current ? position.end_date : nil
    )
  end
end
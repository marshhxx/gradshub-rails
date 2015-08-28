class Degree < ActiveRecord::Base

  # Override the all function so it doesn't return the other value
  def self.all_but_other
    where.not(name: 'Other')
  end

  def self.other
    Degree.find_by_name('Other')
  end

end
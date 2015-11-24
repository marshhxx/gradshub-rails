class Education < ActiveRecord::Base

  belongs_to :candidate
  belongs_to :school
  belongs_to :major
  belongs_to :degree
  belongs_to :country
  belongs_to :state
  # update index
  update_index 'users#candidate', :candidate

  after_initialize :override_other
  after_update :override_other

  validates_presence_of :end_date, :school_id, :major_id, :degree_id
  validates_uniqueness_of :candidate_id, scope: [:school_id, :major_id, :degree_id,
                                                 :country_id, :state_id],
                          :message => 'Education already exists.'

  def self.where(params)
    params[:candidate_id] = User.find_by_uid!(params[:candidate_id]).meta.id
    super.where(params)
  end

  def self.create_with_other(params)
    other_fields.each { |f|
      if params.has_key? "other_#{f}" and not params["other_#{f}"].nil?
        params["#{f}"] = f.classify.constantize.other
      end
    }
    new(params)
  end

  private

  def self.other_fields
    %w(degree major school)
  end

  def override_other
    self.class.other_fields.each { |f|
      attr = self.send(f)
      if attr == f.classify.constantize.other
        self.send(f).name = self.send("other_#{f}")
      end
    }
  end
end
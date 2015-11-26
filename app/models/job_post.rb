class JobPost < ActiveRecord::Base
  belongs_to :employer

  # update index
  update_index 'users#employer', :employer

  after_initialize :override_other
  after_update :override_other

  validates_presence_of :description, :requirements, :type, :salary, :start_date, :end_date, :state
  validates_uniqueness_of :employer_id,
                          :message => 'Job Post already exists.'

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
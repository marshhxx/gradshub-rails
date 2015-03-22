class Education < ActiveRecord::Base
  validates_presence_of :start_date, :school_id, :major_id, :degree_id
  belongs_to :candidate
  belongs_to :school
  belongs_to :major
  belongs_to :degree
  belongs_to :country
  belongs_to :state

  def self.where(params)
    params[:candidate_id] = User.find_by_uid!(params[:candidate_id]).meta.id
    super.where(params)
  end

  def new(params)
    params[:candidate_id] = User.find_by_uid!(params[:candidate_id]).meta.id
    super.new(params)
  end

end
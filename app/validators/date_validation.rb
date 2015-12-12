class DateValidation < ActiveModel::Validator
  def validate(record)
    if record.end_date.present? and record.start_date.present? && record.start_date > record.end_date
      record.errors[:base] << "Start date cannot be greater than end date"
    end
  end
end
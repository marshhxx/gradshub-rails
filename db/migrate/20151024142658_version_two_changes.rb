class VersionTwoChanges < ActiveRecord::Migration

  def change
    change_column_null(:educations, :start_date, true)
    change_column_null(:educations, :end_date, false, DateTime.now)
  end

end

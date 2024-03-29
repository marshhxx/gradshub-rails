class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid

      t.timestamps
    end

    rename_column :companies, :type, :category
  end
end

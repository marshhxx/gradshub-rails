class AddFieldsToUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name , null: false
      t.string :lastname
      t.string :email, null: false
      t.string :encrypted_password,     default: "", null: false
      t.string :uid,  null:false
    end
  end
end

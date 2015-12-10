class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :avatar_url
      t.string :mobile
      t.boolean :enabled

      t.timestamps null: false
    end
  end
end

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :avatar_url
      t.string :mobile
      t.boolean :is_admin, null: false, default: false
      t.boolean :enabled, null: false, default: true

      t.timestamps null: false
    end
  end
end

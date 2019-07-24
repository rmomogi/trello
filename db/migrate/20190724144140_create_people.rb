class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
    	t.string :name, null: false
      t.string :email, null: false
      t.string :role, null: false
      t.timestamps
    end
  end
end

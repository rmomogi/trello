class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
    	t.string :name, null: false
    	t.belongs_to :manager, references: :people
    	t.timestamps
    end
  end
end

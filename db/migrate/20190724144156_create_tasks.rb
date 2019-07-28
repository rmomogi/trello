class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
    	t.string :description
    	t.boolean :done, default: false
    	t.belongs_to :history
      t.timestamps
    end
  end
end

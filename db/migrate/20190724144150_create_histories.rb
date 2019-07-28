class CreateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :histories do |t|
    	t.string :name, null: false
    	t.belongs_to :requester, references: :people, index: true
    	t.string :status, default: :pending
    	t.belongs_to :owner, references: :people, index: true
    	t.datetime :started_at
    	t.datetime :finished_at
    	t.datetime :deadline
    	t.integer :points
      t.timestamps
    end
  end
end

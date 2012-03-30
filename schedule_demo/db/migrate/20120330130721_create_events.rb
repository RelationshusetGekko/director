class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.integer :participant_id

      t.timestamps
    end
  end
end

class CreateTimePunches < ActiveRecord::Migration
  def change
    create_table :time_punches do |t|
      t.datetime :entry
      t.integer :workday_id
      t.boolean :clockedInStatus

      t.timestamps null: false
    end
  end
end

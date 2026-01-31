class CreateActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities do |t|
      t.string :name, null: false
      t.text :description
      t.string :address
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string :activity_type, null: false
      t.boolean :is_event, default: false, null: false
      t.boolean :indoor, default: false, null: false
      t.integer :cost_level, default: 0, null: false
      t.jsonb :hours, default: {}
      t.datetime :start_date
      t.datetime :end_date
      t.string :registration_url
      t.string :website
      t.string :phone
      t.string :source_url
      t.datetime :last_synced_at

      t.timestamps
    end

    add_index :activities, :activity_type
    add_index :activities, :is_event
    add_index :activities, :indoor
    add_index :activities, :cost_level
    add_index :activities, [:latitude, :longitude]
    add_index :activities, [:start_date, :end_date]
  end
end

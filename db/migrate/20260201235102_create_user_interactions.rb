class CreateUserInteractions < ActiveRecord::Migration[8.1]
  def change
    create_table :user_interactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true
      t.integer :rating
      t.datetime :last_completed_at
      t.json :completions, default: []

      t.timestamps
    end

    add_index :user_interactions, [:user_id, :activity_id], unique: true
  end
end

class RemoveBarnesNobleStorytime < ActiveRecord::Migration[8.1]
  def up
    Activity.where("name ILIKE ?", "%barnes%noble%").destroy_all
  end

  def down
  end
end

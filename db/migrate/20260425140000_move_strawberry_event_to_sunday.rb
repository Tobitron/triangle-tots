class MoveStrawberryEventToSunday < ActiveRecord::Migration[8.1]
  def up
    Activity.where(name: "U-Pick Strawberries at Chatham Oaks Farm")
            .update_all(start_date: Time.zone.parse("2026-04-26 13:00:00"))
  end

  def down
    Activity.where(name: "U-Pick Strawberries at Chatham Oaks Farm")
            .update_all(start_date: Time.zone.parse("2026-04-25 13:00:00"))
  end
end

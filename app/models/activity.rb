class Activity < ApplicationRecord
  # Enum for activity types
  enum :activity_type, {
    playground: 'playground',
    library: 'library',
    museum: 'museum',
    park: 'park',
    splash_pad: 'splash_pad',
    indoor_play: 'indoor_play',
    farm: 'farm',
    nature_trail: 'nature_trail',
    class_activity: 'class',
    event: 'event',
    restaurant: 'restaurant'
  }, prefix: true

  # Validations
  validates :name, presence: true
  validates :activity_type, presence: true
  validates :cost_level, inclusion: { in: 0..3 }

  # Event-specific validations
  validates :start_date, :end_date, presence: true, if: :is_event?
  validate :end_date_after_start_date, if: :is_event?

  # Evergreen-specific validations
  validates :hours, presence: true, unless: :is_event?

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end

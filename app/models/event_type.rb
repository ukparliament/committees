# == Schema Information
#
# Table name: event_types
#
#  id          :integer          not null, primary key
#  description :string(5000)     not null
#  is_visit    :boolean          default(FALSE)
#  name        :string(255)
#  system_id   :integer          not null
#
class EventType < ApplicationRecord
  
  def all_events
    Event.find_by_sql([
      "
        SELECT e.*, location.normalised_location_name
        FROM events e
        LEFT JOIN (
          SELECT l.id as location_id, l.name as normalised_location_name
          FROM locations l
        ) location
        ON e.location_id = location.location_id
    
        WHERE e.event_type_id = ?
        ORDER BY e.start_at
      ", id
    ])
  end
  
  def upcoming_events
    Event.find_by_sql([
      "
        SELECT e.*, location.normalised_location_name
        FROM events e
        LEFT JOIN (
          SELECT l.id as location_id, l.name as normalised_location_name
          FROM locations l
        ) location
        ON e.location_id = location.location_id
    
        WHERE e.event_type_id = ?
        AND e.start_at >= NOW()
        AND e.cancelled_at is NULL
        ORDER BY e.start_at
      ", id
    ])
  end
end

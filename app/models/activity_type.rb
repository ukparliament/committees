# == Schema Information
#
# Table name: activity_types
#
#  id   :integer          not null, primary key
#  name :string(255)
#
class ActivityType < ApplicationRecord
  
  def all_event_segments
    EventSegment.find_by_sql([
      "
        SELECT es.*, e.location_name as location_name, l.name as normalised_location_name, at.name AS activity_type_name
        FROM event_segments es
      
        INNER JOIN activity_types at
        ON es.activity_type_id = at.id
      
        INNER JOIN events e
        ON e.id = es.event_id

        LEFT JOIN locations l
        ON e.location_id = l.id
      
        WHERE es.activity_type_id = ?
        ORDER BY es.start_at;
      ", id
    ])
  end
  
  def upcoming_event_segments
    EventSegment.find_by_sql([
      "
        SELECT es.*, e.location_name as location_name, l.name as normalised_location_name, at.name AS activity_type_name
        FROM event_segments es
        
        INNER JOIN activity_types at
        ON es.activity_type_id = at.id
        
        INNER JOIN events e
        ON e.id = es.event_id

        LEFT JOIN locations l
        ON e.location_id = l.id
        
        WHERE es.activity_type_id = ?
        AND es.start_at >= NOW()
        ORDER BY es.start_at;
      ", id
    ])
  end
end

class EventController < ApplicationController
  
  def index
    @page_title = 'Events'
    @all_events = all_events
    @upcoming_events = upcoming_events
  end
  
  def upcoming
    @page_title = 'Events'
    @all_events = all_events
    @upcoming_events = upcoming_events
  end
  
  def all_events
    Event.find_by_sql(
      "
        SELECT e.*, location.normalised_location_name
        FROM events e
        LEFT JOIN (
          SELECT l.id as location_id, l.name as normalised_location_name
          FROM locations l
        ) location
        ON e.location_id = location.location_id
    
        ORDER BY e.start_at desc
      "
    )
  end
  
  def upcoming_events
    Event.find_by_sql(
      "
        SELECT e.*, location.normalised_location_name
        FROM events e
        LEFT JOIN (
          SELECT l.id as location_id, l.name as normalised_location_name
          FROM locations l
        ) location
        ON e.location_id = location.location_id
        
        WHERE e.start_at >= '#{Time.now}'
    
        ORDER BY e.start_at desc
      "
    )
  end
end

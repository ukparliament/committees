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
  
  def show
    event = params[:event]
    @event = get_event( event )
    @page_title = @event.display_name
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
    
        ORDER BY e.start_at
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
        AND e.cancelled_at is NULL
    
        ORDER BY e.start_at
      "
    )
  end
  
  def get_event( event_id )
    Event.find_by_sql(
        "
          SELECT e.*, event_type.event_type_name as event_type_name, location.normalised_location_name
          FROM events e
          
          INNER JOIN (
            SELECT et.id as event_type_id, et.name as event_type_name
            FROM event_types et
          ) event_type
          ON e.event_type_id = event_type.event_type_id
          
          LEFT JOIN (
            SELECT l.id as location_id, l.name as normalised_location_name
            FROM locations l
          ) location
          ON e.location_id = location.location_id
      
          WHERE e.system_id = #{event_id}
          LIMIT 1
        "
      ).first
  end
end

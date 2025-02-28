class EventSegmentController < ApplicationController
  
  def index
    @all_event_segments = all_event_segments
    @upcoming_event_segments = upcoming_event_segments
    @page_title = 'Event segments'
  end
  
  def upcoming
    @all_event_segments = all_event_segments
    @upcoming_event_segments = upcoming_event_segments
    @page_title = 'Event segments'
    @alternate_title = 'Upcoming event segments'
    @ics_url = event_segment_upcoming_url( :format => 'ics' )
  end
  
  def show
    event_segment = params[:event_segment]
    @event_segment = get_event( event_segment )
    @page_title = @event_segment.display_name
  end
  
  def all_event_segments
    EventSegment.find_by_sql(
      "
        SELECT es.*, e.location_name as location_name, l.name as normalised_location_name, at.name AS activity_type_name
        FROM event_segments es
      
        INNER JOIN activity_types at
        ON es.activity_type_id = at.id
      
        INNER JOIN events e
        ON e.id = es.event_id
      
      
        LEFT JOIN locations l
        ON e.location_id = l.id
      
      
        ORDER BY es.start_at;
      "
    )
  end
  
  def upcoming_event_segments
    EventSegment.find_by_sql(
      "
        SELECT es.*, e.location_name as location_name, l.name as normalised_location_name, at.name AS activity_type_name
        FROM event_segments es
        
        INNER JOIN activity_types at
        ON es.activity_type_id = at.id
        
        INNER JOIN events e
        ON e.id = es.event_id
        
        
        LEFT JOIN locations l
        ON e.location_id = l.id
        
        
        WHERE es.start_at >= NOW()
        ORDER BY es.start_at;
      "
    )
  end
  
  def get_event( event_segment )
    EventSegment.find_by_sql([
      "
        SELECT es.*, e.location_name as location_name, l.name as normalised_location_name
        FROM event_segments es, events e
        LEFT JOIN locations l
        ON e.location_id = l.id
        WHERE es.event_id = e.id
        AND es.system_id = ?
        LIMIT 1;
      ", event_segment
    ]).first
  end
end

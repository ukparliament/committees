class EventTypeController < ApplicationController
  
  def index
    @page_title = 'Event types'
    @event_types = EventType.all.order( 'name' )
  end
  
  def show
    event_type = params[:event_type]
    @event_type = EventType.find_by_system_id( event_type )
    @page_title = @event_type.name
    @all_events = @event_type.all_events
    @upcoming_events = @event_type.upcoming_events
  end
  
  def upcoming
    event_type = params[:event_type]
    @event_type = EventType.find_by_system_id( event_type )
    @page_title = @event_type.name
    @all_events = @event_type.all_events
    @upcoming_events = @event_type.upcoming_events
    @alternate_title = "Upcoming events - #{@event_type.name}"
    @ics_url = event_type_upcoming_url( :format => 'ics' )
  end
end

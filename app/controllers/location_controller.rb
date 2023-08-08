class LocationController < ApplicationController
  
  def index
    @locations = Location.all.order( 'name' )
    @page_title = 'Locations'
  end
  
  def show
    location = params[:location]
    @location = Location.find_by_system_id( location )
    @page_title = @location.name
    @all_events = @location.all_events
    @upcoming_events = @location.upcoming_events
  end
  
  def upcoming
    location = params[:location]
    @location = Location.find_by_system_id( location )
    @page_title = @location.name
    @all_events = @location.all_events
    @upcoming_events = @location.upcoming_events
    @alternate_title = "Upcoming events in #{@location.name}"
    @ics_url = location_upcoming_url( :format => 'ics' )
  end
end

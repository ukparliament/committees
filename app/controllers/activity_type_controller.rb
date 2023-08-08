class ActivityTypeController < ApplicationController
  
  def index
    @activity_types = ActivityType.all
    @page_title = 'Activity types'
  end
  
  def show
    activity_type = params[:activity_type]
    @activity_type = ActivityType.find( activity_type )
    @page_title = @activity_type.name
    @all_event_segments = @activity_type.all_event_segments
    @upcoming_event_segments = @activity_type.upcoming_event_segments
  end
  
  def upcoming
    activity_type = params[:activity_type]
    @activity_type = ActivityType.find( activity_type )
    @page_title = @activity_type.name
    @all_event_segments = @activity_type.all_event_segments
    @upcoming_event_segments = @activity_type.upcoming_event_segments
    @ics_link = activity_type_upcoming_url( :format => 'ics' )
  end
end

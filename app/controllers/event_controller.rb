class EventController < ApplicationController
  
  def index
    @page_title = 'Events'
    @all_events = Event.all
  end
end

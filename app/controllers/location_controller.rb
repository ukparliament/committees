class LocationController < ApplicationController
  
  def index
    @locations = Location.all.order( 'name' )
    @page_title = 'Locations'
  end
end

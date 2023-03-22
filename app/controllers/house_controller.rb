class HouseController < ApplicationController
  
  def index
    @page_title = 'Houses'
    @houses = ParliamentaryHouse.all.order( 'label' )
  end
  
  def show
    house = params[:house]
    @house = ParliamentaryHouse.find( house )
    @page_title = @house.label
  end
  
  def current
    house = params[:house]
    @house = ParliamentaryHouse.find( house )
    @page_title = @house.label
  end
end

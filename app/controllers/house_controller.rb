class HouseController < ApplicationController
  
  def index
    @page_title = 'Houses'
    @houses = ParliamentaryHouse.all.order( 'label' )
  end
  
  def show
    house = params[:house]
    @house = ParliamentaryHouse.find( house )
    @page_title = @house.label
    @all_committees = @house.all_committees
    @current_committees = @house.current_committees
  end
  
  def current
    house = params[:house]
    @house = ParliamentaryHouse.find( house )
    @page_title = @house.label
    @all_committees = @house.all_committees
    @current_committees = @house.current_committees
  end
end

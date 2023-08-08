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
  
  def oral_evidence_transcripts
    house = params[:house]
    @house = ParliamentaryHouse.find( house )
    @page_title = @house.label
    @oral_evidence_transcripts = @house.oral_evidence_transcripts
    @alternate_title = "Oral evidence transcripts in the #{@house.label}"
    @rss_url = house_oral_evidence_transcripts_url( :format => 'rss' )
  end
end

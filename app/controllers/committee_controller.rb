class CommitteeController < ApplicationController
  
  def index
    @page_title = 'All committees'
    @committees = Committee.all.order( 'name' )
  end
  
  def current
    @page_title = 'Current committees'
    @committees = Committee.all.where( "end_on < ?", Date.today ).order( 'name' )
  end
  
  def show
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
  end
end
